//
//  SaveDailyReimbursementApplyVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/6.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveDailyReimbursementApplyVC.h"
#import "PublicFMWaybillQueryVC.h"

#import "LLImagePickerView.h"
#import "NSData+HTTPRequest.h"

@interface SaveDailyReimbursementApplyVC () {
    NSUInteger uploadImageIndex;
}

@property (strong, nonatomic) LLImagePickerView *imagePickerView;
@property (strong, nonatomic) NSMutableArray *selectedImageArray;

@end

@implementation SaveDailyReimbursementApplyVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_DailyReimbursementSave;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.tableFooterView = self.pickerFooter;
//    [self.imagePickerView observeViewHeight:^(CGFloat height) {
//        self.pickerFooter.height = height;
//        self.tableView.tableFooterView = nil;
//        self.tableView.tableFooterView = self.pickerFooter;
//    }];
    self.tableView.tableFooterView = nil;
    [self.imagePickerView observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        [self.selectedImageArray removeAllObjects];
        [self.selectedImageArray addObjectsFromArray:list];
    }];
}

- (void)setupNav {
    [self createNavWithTitle:@"报销申请" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)searchButtonAction {
    [self dismissKeyboard];
    if (!self.condition.daily_name) {
        [self showHint:@"请选择报销科目"];
    }
    else if ([self.condition.daily_fee intValue] < 1) {
        [self showHint:@"请输入正确的报销金额"];
    }
    else {
        [self doSaveDailyReimburseFunction:YES];
    }
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"报销科目",@"subTitle":@"请选择",@"key":@"daily_name"},
                       @{@"title":@"报销金额",@"subTitle":@"请输入",@"key":@"daily_fee"},
                       @{@"title":@"关联运单",@"subTitle":@"请选择",@"key":@"bind_waybill"},
                       @{@"title":@"报销备注",@"subTitle":@"请输入",@"key":@"note"},
                       @{@"title":@"报销凭证",@"subTitle":@"",@"key":@"voucher"},];
    NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:@"daily_name"];
    if (dicArray.count) {
        self.condition.daily_name = dicArray[0];
    }
//    self.condition.daily_fee = @"0";
}

- (void)doSaveDailyReimburseFunction:(BOOL)isReset {
    if (isReset) {
        uploadImageIndex = 0;
        self.condition.voucher = @"";
    }
    if (uploadImageIndex < self.selectedImageArray.count) {
        [self doUploadBase64ImageFunction:self.selectedImageArray[uploadImageIndex]];
    }
    else {
        [self doReimburseSaveDailyReimburseFunction];
    }
}

- (void)doReimburseSaveDailyReimburseFunction {
    [self doShowHudFunction];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"daily_name" : self.condition.daily_name.item_val, @"daily_fee" : [NSString stringWithFormat:@"%d", [self.condition.daily_fee intValue]]}];
    if (self.condition.bind_waybill) {
        [m_dic setObject:self.condition.bind_waybill.waybill_id forKey:@"bind_waybill_id"];
    }
    if (self.condition.note.length) {
        [m_dic setObject:self.condition.note forKey:@"note"];
    }
    if (self.condition.voucher.length) {
        [m_dic setObject:self.condition.voucher forKey:@"voucher"];
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_reimburse_saveDailyReimburseFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself dailyReimbursementSaveSuccess];
            }
            else {
                [weakself showHint:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)doUploadBase64ImageFunction:(LLImagePickerModel *)imageModel {
    NSData *imageData = dataOfImageCompression(imageModel.image, NO);
    [self doShowHudFunction];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"resource_type" : [NSString stringWithFormat:@"%@", @"reimburse"], @"resource_suffix" : [imageData getImageType]}];
    [m_dic setObject:[NSString stringWithFormat:@"%@", [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]] forKey:@"base64_content"];
    [m_dic setObject:[NSString stringWithFormat:@"%@%@", (self.condition.bind_waybill ? self.condition.bind_waybill.goods_number : [UserPublic getInstance].userData.service_name), self.condition.daily_name.item_name] forKey:@"resource_note"];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_resource_uploadBase64ImageFunction" Parm:m_dic URLFooter:@"/resource/common/data.do" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                uploadImageIndex++;
                self.condition.voucher = [NSString stringWithFormat:@"%@%@%@", notNilString(self.condition.voucher, @""), self.condition.voucher.length ? @"," : @"", item.message];
                [self doSaveDailyReimburseFunction:NO];
            }
            else {
                [weakself showHint:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)dailyReimbursementSaveSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_DailyReimbursementApplyRefresh object:nil];
    [self showHint:@"保存成功"];
    [self goBackWithDone:YES];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"bind_waybill"]) {
        PublicFMWaybillQueryVC *vc = [PublicFMWaybillQueryVC new];
        vc.type = FMWaybillQueryType_DailyReimburse;
        QKWEAKSELF;
        vc.doneBlock = ^(NSObject *object){
            if ([object isKindOfClass:[AppWayBillDetailInfo class]]) {
                weakself.condition.bind_waybill = [object copy];
                [weakself.tableView reloadData];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [super selectRowAtIndexPath:indexPath];
}

#pragma mark - getter
- (LLImagePickerView *)imagePickerView {
    if (!_imagePickerView) {
        _imagePickerView = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, kCellHeightBig * 3, 0) CountOfRow:3];
        _imagePickerView.backgroundColor = [UIColor clearColor];
        _imagePickerView.allowMultipleSelection = NO;
        _imagePickerView.maxImageSelected = 3;
    }
    return _imagePickerView;
}

- (NSMutableArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray new];
    }
    return _selectedImageArray;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    NSDictionary *dic = self.showArray[indexPath.row];
    NSString *key = dic[@"key"];
    if ([key isEqualToString:@"voucher"]) {
        rowHeight = kCellHeightBig;
    }
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        rowHeight += kEdge;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"voucher"]) {
        NSString *CellIdentifier = @"voucher_cell";
        SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
            cell.baseView.textField.enabled = NO;
            CGFloat width  = cell.baseView.width - cell.baseView.textLabel.left - [AppPublic textSizeWithString:m_dic[@"title"] font:cell.baseView.textLabel.font constantHeight:cell.baseView.textLabel.height].width - 2 * kEdgeSmall;
            if (self.imagePickerView.width > width) {
                self.imagePickerView.width = width;
            }
            self.imagePickerView.right = cell.baseView.width;
            [cell.baseView addSubview:self.imagePickerView];
        }
        cell.baseView.textLabel.text = m_dic[@"title"];
        cell.baseView.textField.placeholder = m_dic[@"subTitle"];
        cell.baseView.textField.text = @"";
        cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
        self.imagePickerView.preShowMedias = self.selectedImageArray;
//        NSString *voucher = [self.showData valueForKey:key];
//        if (voucher.length) {
//            self.imagePickerView.preShowMedias = [[self.showData valueForKey:key] componentsSeparatedByString:@","];
//        }
//        else {
//            self.imagePickerView.preShowMedias = nil;
//        }
//        if (self.imagePickerView.preShowMedias.count) {
//            cell.baseView.textField.placeholder = @"";
//        }
        
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
