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
#import "BlockActionSheet.h"

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
    else if (!self.headerView.data.number) {
        [self showHint:@"请输入货物件数"];
    }
    else {
        if (!self.headerView.data.freight) {
            self.headerView.data.freight = @"0";
        }
        if (!self.headerView.data.weight) {
            self.headerView.data.weight = @"0";
        }
        if (!self.headerView.data.volume) {
            self.headerView.data.volume = @"0";
        }
        
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
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AppHistoryGoodsInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]]];
            [weakself.tableView reloadData];
        }
    }];
}

- (void)touchRowButtonAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    if (indexPath.row == 0) {
        NSString *key = key_ServiceGood;
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppGoodInfo *m_data in dataArray) {
                [m_array addObject:m_data.good_name];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    AppGoodInfo *good = dataArray[buttonIndex - 1];
                    weakself.headerView.data.goods_name = good.good_name;
                    [weakself.headerView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                [[UserPublic getInstance].dataMapDic removeObjectForKey:key];
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullServiceGoodArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if (indexPath.row == 1) {
        NSString *key = key_ServicePackage;
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppPackageInfo *m_data in dataArray) {
                [m_array addObject:m_data.package_name];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    AppPackageInfo *package = dataArray[buttonIndex - 1];
                    weakself.headerView.data.packge = package.package_name;
                    [weakself.headerView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                [[UserPublic getInstance].dataMapDic removeObjectForKey:key];
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullServicePackageArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
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
        titleLable1.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
        titleLable1.textColor = baseTextColor;
        [bgView addSubview:titleLable1];
        titleLable1.text = @"历史发货";
        
        return bgView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"history_cell";
    FourItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FourItemsListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.firstRightLabel.width = [AppPublic textSizeWithString:@"时间：2017-01-01 " font:cell.firstRightLabel.font constantHeight:cell.firstRightLabel.height].width;
        cell.firstRightLabel.right = cell.baseView.width - kEdge;
        cell.firstLeftLabel.width = cell.firstRightLabel.left - 2 * kEdge;
        
        cell.secondRightLabel.width = [AppPublic textSizeWithString:@"价格：123456" font:cell.secondRightLabel.font constantHeight:cell.secondRightLabel.height].width;
        cell.secondRightLabel.right = cell.baseView.width - kEdge;
        cell.secondLeftLabel.width = cell.secondRightLabel.left - 2 * kEdge;
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
    [self dismissKeyboard];
    
    AppHistoryGoodsInfo *item = self.dataSource[indexPath.row];
    NSArray *m_array = [item.goods_info componentsSeparatedByString:@"/"];
    if (m_array.count == 5) {
        self.headerView.data.goods_name = m_array[0];
        self.headerView.data.packge = m_array[1];
//        self.headerView.data.number = [m_array[2] intValue];
//        self.headerView.data.weight = [m_array[3] doubleValue];
//        self.headerView.data.volume = [m_array[4] doubleValue];
    }
//    self.headerView.data.freight = [item.total_amount longLongValue];
    [self.headerView.tableView reloadData];
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_AddGoodsListHeaderViewButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        if (indexPath) {
            [self touchRowButtonAtIndexPath:indexPath];
        }
    }
}

@end
