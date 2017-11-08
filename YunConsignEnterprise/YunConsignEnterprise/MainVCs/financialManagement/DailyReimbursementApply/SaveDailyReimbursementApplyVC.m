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
@property (strong, nonatomic) UIView *pickerFooter;
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
    self.tableView.tableFooterView = self.pickerFooter;
    [self.imagePickerView observeViewHeight:^(CGFloat height) {
        self.pickerFooter.height = height;
        self.tableView.tableFooterView = nil;
        self.tableView.tableFooterView = self.pickerFooter;
    }];
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
        return;
    }
    if ([self.condition.daily_fee intValue] < 1) {
        [self showHint:@"请输入正确的报销金额"];
        return;
    }
    [self doSaveDailyReimburseFunction:YES];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"报销科目",@"subTitle":@"请选择",@"key":@"daily_name"},
                       @{@"title":@"报销金额",@"subTitle":@"请输入",@"key":@"daily_fee"},
                       @{@"title":@"关联运单",@"subTitle":@"请选择",@"key":@"bind_waybill_id"},
                       @{@"title":@"报销备注",@"subTitle":@"请输入",@"key":@"note"},];
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
    if (self.condition.bind_waybill_id) {
        [m_dic setObject:self.condition.bind_waybill_id forKey:@"bind_waybill_id"];
    }
    if (self.condition.note) {
        [m_dic setObject:self.condition.note forKey:@"note"];
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
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"resource_type" : [NSString stringWithFormat:@"%d", (int)RESOURCE_TYPE_Reimburse], @"resource_suffix" : [imageData getImageType], @"base64_content" : [imageData base64EncodedStringWithOptions:0]}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_resource_uploadBase64ImageFunction" Parm:m_dic URLFooter:@"/resource/common/data.do" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                
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
    if ([key isEqualToString:@"bind_waybill_id"]) {
        PublicFMWaybillQueryVC *vc = [PublicFMWaybillQueryVC new];
        vc.type = FMWaybillQueryType_DailyReimburse;
        QKWEAKSELF;
        vc.doneBlock = ^(NSObject *object){
            if ([object isKindOfClass:[AppWayBillDetailInfo class]]) {
                weakself.condition.bind_waybill_id = [((AppWayBillDetailInfo *)object).waybill_id copy];
                [weakself.tableView reloadData];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [super selectRowAtIndexPath:indexPath];
}

#pragma mark - getter
- (UIView *)pickerFooter {
    if (!_pickerFooter) {
        _pickerFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, self.imagePickerView.height)];
        [_pickerFooter addSubview:self.imagePickerView];
    }
    return _pickerFooter;
}

- (LLImagePickerView *)imagePickerView {
    if (!_imagePickerView) {
        _imagePickerView = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, 0) CountOfRow:4];
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

@end