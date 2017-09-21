//
//  AddGoodsVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AddGoodsVC.h"

#import "FourItemsListCell.h"

@interface AddGoodsVC ()

@property (strong, nonatomic) NSObject *data;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation AddGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
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
    if (self.doneBlock) {
        self.doneBlock(self.data);
    }
    [self goBack];
}

- (void)pullDatasource {
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryShipperHistoryWaybillFunction" Parm:@{@"shipper_phone" : self.senderInfo.customer.phone}  completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[APPWayBillGoodInfo mj_objectArrayWithKeyValuesArray:responseBody]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
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

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
//            return self.showArray.count;
        }
            break;
            
        case 1:{
            return self.dataSource.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return [FourItemsListCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return kCellHeightMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return STATUS_HEIGHT;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (self.dataSource.count) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, STATUS_HEIGHT)];
            bgView.backgroundColor = [UIColor clearColor];
            
            UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, bgView.width - 2 * kEdge, bgView.height)];
            titleLable1.textAlignment = NSTextAlignmentCenter;
            titleLable1.font = [AppPublic appFontOfSize:appLabelFontSize];
            titleLable1.textColor = baseTextColor;
            [bgView addSubview:titleLable1];
            titleLable1.text = @"历史发货";
            
            return bgView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"history_cell";
        FourItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[FourItemsListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        APPWayBillGoodInfo *item = self.dataSource[indexPath.row];
        cell.firstLeftLabel.text = [NSString stringWithFormat:@"门店：%@", item.service_info];
        cell.firstRightLabel.text = [NSString stringWithFormat:@"时间：%@", item.consignment_time];
        cell.secondLeftLabel.text = [NSString stringWithFormat:@"明细：%@", item.goods_info];
        cell.secondRightLabel.text = [NSString stringWithFormat:@"价格：%@", item.total_amount];
        
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        
    }
}

@end
