//
//  AddGoodsVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AddGoodsVC.h"

#import "FourItemsListCell.h"
#import "AddGoodsListHeaderView.h"

@interface AddGoodsVC ()

@property (strong, nonatomic) AddGoodsListHeaderView *headerView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation AddGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self pullDatasource];
}

- (void)setupNav {
    [self createNavWithTitle:@"添加货物" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"确定", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonAction {
    [self dismissKeyboard];
    [self doDoneAction];
}

- (void)doDoneAction{
    if (!self.headerView.data.goods_name) {
        [self showHint:@"请输入货物名称"];
    }
    else if (!self.headerView.data.packge) {
        [self showHint:@"请输入包装类型"];
    }
    else {
        if (self.doneBlock) {
            self.doneBlock(self.headerView.data);
        }
        [self goBack];
    }
}

- (void)pullDatasource {
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryShipperHistoryWaybillFunction" Parm:@{@"shipper_phone" : self.senderInfo.customer.phone}  completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[AppHistoryGoodsInfo mj_objectArrayWithKeyValuesArray:responseBody]];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (AddGoodsListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [AddGoodsListHeaderView new];
    }
    return _headerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FourItemsListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource.count) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        bgView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, bgView.width - 2 * kEdge, bgView.height)];
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = [AppPublic appFontOfSize:appLabelFontSize];
        titleLable1.textColor = baseTextColor;
        [bgView addSubview:titleLable1];
        titleLable1.text = @"历史发货";
        
        return bgView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"history_cell";
    FourItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FourItemsListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AppHistoryGoodsInfo *item = self.dataSource[indexPath.row];
    cell.firstLeftLabel.text = [NSString stringWithFormat:@"门店：%@", item.service_info];
    cell.firstRightLabel.text = [NSString stringWithFormat:@"时间：%@", item.consignment_time];
    cell.secondLeftLabel.text = [NSString stringWithFormat:@"明细：%@", item.goods_info];
    cell.secondRightLabel.text = [NSString stringWithFormat:@"价格：%@", item.total_amount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
