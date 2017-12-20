//
//  WaybillReceiveVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillReceiveVC.h"
#import "PublicQueryConditionVC.h"
#import "WaybillCustReceiveVC.h"
#import "WaybillReturnVC.h"
#import "PublicWaybillDetailVC.h"

#import "WaybillReceiveCell.h"
#import "LLImagePickerView.h"
#import "PublicAlertView.h"
#import "NSData+HTTPRequest.h"

@interface WaybillReceiveVC () {
    NSUInteger uploadImageIndex;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) AppQueryConditionInfo *condition;

@property (strong, nonatomic) NSMutableArray *selectedImageArray;
@property (strong, nonatomic) NSString *selectedVoucher;

@end

@implementation WaybillReceiveVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_WaybillReceiveRefresh object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [self beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewRightButton([UIImage imageNamed:@"navbar_icon_search"], nil);
            [btn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnAction {
    PublicQueryConditionVC *vc = [PublicQueryConditionVC new];
    vc.type = QueryConditionType_WaybillReceive;
    vc.condition = [self.condition copy];
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object){
        if ([object isKindOfClass:[AppQueryConditionInfo class]]) {
            weakself.condition = (AppQueryConditionInfo *)object;
            [weakself.tableView.mj_header beginRefreshing];
        }
    };
    [vc showFromVC:self];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
        if (self.condition.start_service) {
            [m_dic setObject:self.condition.start_service.service_id forKey:@"start_service_id"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receive_queryCanReceiveWaybillListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppCanReceiveWayBillInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakself updateTableViewFooter];
            }
            [weakself.tableView reloadData];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)doCancelReceiveWaybillFunction:(AppCanReceiveWayBillInfo *)item {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : item.waybill_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receive_cancelReceiveWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
//                [weakself showHint:@"操作完成"];
                [weakself.tableView.mj_header beginRefreshing];
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

- (void)doQueryWaybillVoucherByIdFunction:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    AppCanReceiveWayBillInfo *data = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : data.waybill_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receive_queryWaybillVoucherByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            NSArray *m_array = [AppVoucherInfo mj_objectArrayWithKeyValuesArray:item.items];
            [weakself showImagePickerAlert:m_array indexPath:indexPath];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)updateTableViewHeader {
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
}

- (void)updateTableViewFooter{
    QKWEAKSELF;
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
}

- (void)endRefreshing {
    [self doHideHudFunction];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)showImagePickerAlert:(NSArray *)array indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    AppCanReceiveWayBillInfo *item = self.dataSource[indexPath.row];
    LLImagePickerView *_imagePickerView = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, screen_width - 2 * kEdgeHuge, 80) CountOfRow:3];
    _imagePickerView.backgroundColor = [UIColor clearColor];
    _imagePickerView.allowMultipleSelection = NO;
    _imagePickerView.maxImageSelected = 3;
    
    QKWEAKSELF;
    [_imagePickerView observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        [weakself.selectedImageArray removeAllObjects];
        weakself.selectedVoucher = [NSString new];
        for (LLImagePickerModel *model in list) {
            if (model.imageUrlString.length) {
                weakself.selectedVoucher = [NSString stringWithFormat:@"%@%@%@", notNilString(weakself.selectedVoucher, @""), weakself.selectedVoucher.length ? @"," : @"", model.imageUrlString];
            }
            else {
                [weakself.selectedImageArray addObject:model];
            }
        }
    }];
    
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:array.count];
    for (AppVoucherInfo *item in array) {
        [m_array addObject:item.voucher];
    }
    _imagePickerView.preShowMedias = [NSArray arrayWithArray:m_array];
    
    PublicAlertView *alert = [[PublicAlertView alloc] initWithContentView:_imagePickerView andTitle:item.goods_number callBlock:^(PublicAlertView *m_view, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (weakself.selectedImageArray.count) {
                [weakself doSaveDailyReimburseFunction:YES indexPath:indexPath];
            }
        }
    }];
    [alert show];
}

- (void)doSaveDailyReimburseFunction:(BOOL)isReset indexPath:(NSIndexPath *)indexPath {
    if (isReset) {
        uploadImageIndex = 0;
    }
    if (uploadImageIndex < self.selectedImageArray.count) {
        [self doUploadBase64ImageFunction:self.selectedImageArray[uploadImageIndex] indexPath:indexPath];
    }
    else {
        [self doReimburseSaveDailyReimburseFunction:indexPath];
    }
}

- (void)doReimburseSaveDailyReimburseFunction:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    AppCanReceiveWayBillInfo *data = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : data.waybill_id, @"voucher" : self.selectedVoucher}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receive_updateWaybillVoucherByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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

- (void)doUploadBase64ImageFunction:(LLImagePickerModel *)imageModel  indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    AppCanReceiveWayBillInfo *data = self.dataSource[indexPath.row];
    
    NSData *imageData = dataOfImageCompression(imageModel.image, NO);
    [self doShowHudFunction];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"resource_type" : [NSString stringWithFormat:@"%@", @"waybill"], @"resource_suffix" : [imageData getImageType]}];
    [m_dic setObject:[NSString stringWithFormat:@"%@", [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]] forKey:@"base64_content"];
    [m_dic setObject:[NSString stringWithFormat:@"%@%@", (data.goods_number ? data.goods_number : [UserPublic getInstance].userData.service_name), @"waybill"] forKey:@"resource_note"];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_resource_uploadBase64ImageFunction" Parm:m_dic URLFooter:@"/resource/common/data.do" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                uploadImageIndex++;
                self.selectedVoucher = [NSString stringWithFormat:@"%@%@%@", notNilString(self.selectedVoucher, @""), self.selectedVoucher.length ? @"," : @"", item.message];
                [self doSaveDailyReimburseFunction:NO indexPath:(NSIndexPath *)indexPath];
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
    [self showHint:@"保存成功"];
    
}

#pragma mark - getter
- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
        _condition.start_time = [_condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
    }
    return _condition;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray new];
    }
    return _selectedImageArray;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCanReceiveWayBillInfo *item = self.dataSource[indexPath.row];
    return [WaybillReceiveCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:isTrue(item.is_cash_on_delivery) ? 3 : 2];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"way_bill_receive_cell";
    WaybillReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[WaybillReceiveCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PublicWaybillDetailVC *vc = [PublicWaybillDetailVC new];
    vc.type = WaybillDetailType_WaybillReceive;
    vc.data = self.dataSource[indexPath.row];
    [self doPushViewController:vc animated:YES];
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        AppCanReceiveWayBillInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                //凭证
                [self doQueryWaybillVoucherByIdFunction:indexPath];
            }
                break;
                
            case 1:{
                //原货返回
                WaybillReturnVC *vc = [WaybillReturnVC new];
                vc.baseData = [AppWayBillInfo mj_objectWithKeyValues:[self.dataSource[indexPath.row] mj_keyValues]];
                [self doPushViewController:vc animated:YES];
            }
                break;
                
            case 2:{
                //打印
                [self doShowHintFunction:defaultNoticeNotComplete];
            }
                break;
                
            case 3:{
                //自提
                WaybillCustReceiveVC *vc = [WaybillCustReceiveVC new];
                vc.billData = self.dataSource[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
