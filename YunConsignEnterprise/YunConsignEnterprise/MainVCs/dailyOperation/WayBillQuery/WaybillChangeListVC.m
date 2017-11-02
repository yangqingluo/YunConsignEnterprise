//
//  WaybillChangeListVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillChangeListVC.h"

#import "SingleInputCell.h"
#import "WaybillChangeDetailCell.h"

@interface WaybillChangeListVC (){
    NSInteger selectedSection;
}

@end

@implementation WaybillChangeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"修改跟踪" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : self.detailData.waybill_id, @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillChangeListByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppWaybillChangeInfo  mj_objectArrayWithKeyValuesArray:item.items]];
            
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

#pragma mark - getter


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return selectedSection == section ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        return [WaybillChangeDetailCell tableView:tableView heightForRowAtIndexPath:indexPath data:self.dataSource[indexPath.section]];
    }
    return kCellHeightFilter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kEdge;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return kEdge;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppWaybillChangeInfo *item = self.dataSource[indexPath.section];
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"way_bill_change_cell";
        SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseView.textField.enabled = NO;
            [cell.baseView.lineView removeFromSuperview];
            [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, 0, screen_width, appSeparaterLineSize))];
            [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath] - appSeparaterLineSize, screen_width, appSeparaterLineSize))];
        }
        cell.baseView.textLabel.text = [NSString stringWithFormat:@"时间：%@", item.operate_time];
        cell.baseView.textField.text = [NSString stringWithFormat:@"%@-%@ %@", item.open_city_name, item.service_name, item.operator_name];
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"way_bill_change_detail_cell";
        WaybillChangeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[WaybillChangeDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.data = item;
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        if (selectedSection == indexPath.section) {
            selectedSection = -1;
        }
        else {
            selectedSection = indexPath.section;
        }
        [tableView reloadData];
    }
}

@end
