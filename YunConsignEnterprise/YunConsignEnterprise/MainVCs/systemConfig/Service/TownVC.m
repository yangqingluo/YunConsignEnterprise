//
//  TownVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/4/12.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "TownVC.h"
#import "SaveTownVC.h"

@interface TownVC ()

@end

@implementation TownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"中转站设置" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"添加", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBtnAction {
    SaveTownVC *vc = [SaveTownVC new];
    vc.service = self.service;
    [self goToSaveVC:vc];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    [m_dic setObject:self.service.service_id forKey:@"service_id"];
    if (self.condition) {
        
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryTownListById" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppTownInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakself updateTableViewFooter];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)goToSaveVC:(PublicSaveVC *)vc {
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object) {
        [weakself.tableView.mj_header beginRefreshing];
    };
    [self doPushViewController:vc animated:YES];
}

- (void)doRemovingDataAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.dataSource.count - 1) {
        [self doShowHintFunction:@"数据越界"];
        return;
    }
    
    AppTownInfo *item = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"town_id" : item.town_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_deleteTownById" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself removeItemSuccessAtIndexPath:indexPath];
            }
            else {
                [weakself doShowHintFunction:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = kCellHeightFilter;
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        rowHeight += kEdge;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        cell.baseView.textField.enabled = NO;
    }
    AppTownInfo *item = self.dataSource[indexPath.row];
    cell.baseView.textLabel.text = item.town_name;
    cell.baseView.textField.placeholder = @"";
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SaveTownVC *vc = [SaveTownVC new];
    vc.baseData = self.dataSource[indexPath.row];
    vc.service = self.service;
    [self goToSaveVC:vc];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
