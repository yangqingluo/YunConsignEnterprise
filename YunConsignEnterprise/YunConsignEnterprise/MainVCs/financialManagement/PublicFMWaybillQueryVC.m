//
//  PublicFMWaybillQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicFMWaybillQueryVC.h"

#import "PublicChangeableInputHeaderView.h"
#import "PublicFMWaybillQueryCell.h"

@interface PublicFMWaybillQueryVC ()

@property (strong, nonatomic) PublicChangeableInputHeaderView *headerView;

@end

@implementation PublicFMWaybillQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.headerView];
    self.tableView.top = self.headerView.bottom;
    self.tableView.height = self.view.height - self.headerView.bottom;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : @"查询运单" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)searchButtonAction {
    [self dismissKeyboard];
    if (!self.headerView.baseView.textField.text.length) {
        [self doShowHintFunction:@"请输入运单号或货号"];
        return;
    }
    [self doQueryWaybillFunction:self.headerView.baseView.textField.text];
}

- (void)doDoneAction {
    if (self.doneBlock) {
        self.doneBlock(self.selectedData);
    }
}

- (void)doQueryWaybillFunction:(NSString *)waybill_info {
    if (!waybill_info) {
        return;
    }
    
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    [m_dic setObject:waybill_info forKey:@"query_val"];
    [m_dic setObject:self.headerView.changeableData.item_val forKey:@"query_column"];
    
    NSString *m_code = nil;
    switch (self.type) {
        case FMWaybillQueryType_DailyReimburse:{
//            [m_dic setObject:waybill_info forKey:@"waybill_info"];
            m_code = @"hex_reimburse_queryWaybillInDailyReimburseFunction";
        }
            break;
            
        case FMWaybillQueryType_CodLoanApply:{
//            [m_dic setObject:waybill_info forKey:@"number"];
            m_code = @"hex_loan_queryWaybillListByNumberFunction";
        }
            break;
            
        default:
            break;
    }
    if (!m_code) {
        return;
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:m_code Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself.dataSource removeAllObjects];
                [weakself.dataSource addObjectsFromArray:[AppWayBillDetailInfo mj_objectArrayWithKeyValuesArray:item.items]];
                [weakself.tableView reloadData];
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

- (void)tappedChangeableLabel:(UITapGestureRecognizer *)gesture {
    NSString *m_key = @"query_column_waybill";
    NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:m_key];
    if (dicArray.count) {
        NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dicArray.count];
        for (AppDataDictionary *m_data in dicArray) {
            [m_array addObject:m_data.item_name];
        }
        QKWEAKSELF;
        BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", @"查询字段"] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
            if (buttonIndex > 0 && (buttonIndex - 1) < dicArray.count) {
                weakself.headerView.changeableData = dicArray[buttonIndex - 1];
            }
        } otherButtonTitlesArray:m_array];
        [sheet showInView:self.view];
    }
}

#pragma mark - getter
- (PublicChangeableInputHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PublicChangeableInputHeaderView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom + kEdge, screen_width, kCellHeightFilter)];
        _headerView.baseView.textLabel.text = @"请选择查询字段";
        _headerView.baseView.textLabel.textAlignment = NSTextAlignmentCenter;
        _headerView.baseView.textField.placeholder = @"请输入查询内容";
        _headerView.baseView.textField.textAlignment = NSTextAlignmentLeft;
        _headerView.baseView.textField.clearButtonMode = UITextFieldViewModeAlways;
        _headerView.baseView.textField.keyboardType = UIKeyboardTypeURL;
        [_headerView.searchBtn addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.baseView adjustSubviews];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedChangeableLabel:)];
        _headerView.baseView.textLabel.userInteractionEnabled = YES;
        [_headerView.baseView.textLabel addGestureRecognizer:tapGesture];
        
        NSString *m_key = @"query_column_waybill";
        NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:m_key];
        if (dicArray.count) {
            _headerView.changeableData = dicArray[0];
        }
    }
    return _headerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PublicFMWaybillQueryCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PublicFMWaybillQuery_cell";
    PublicFMWaybillQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicFMWaybillQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = [indexPath copy];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedData = self.dataSource[indexPath.row];
    [self goBackWithDone:YES];
}

@end
