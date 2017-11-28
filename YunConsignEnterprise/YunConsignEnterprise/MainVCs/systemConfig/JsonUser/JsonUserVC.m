//
//  JsonUserVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/28.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "JsonUserVC.h"
#import "PublicQueryConditionVC.h"
#import "SaveJsonUserVC.h"

#import "JsonUserCell.h"

@interface JsonUserVC ()

@property (strong, nonatomic) UIView *footerView;

@end

@implementation JsonUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height = self.footerView.top - self.tableView.top;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
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

- (void)searchBtnAction {
    PublicQueryConditionVC *vc = [PublicQueryConditionVC new];
    vc.type = QueryConditionType_JsonUser;
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

- (void)addButtonAction {
    SaveJsonUserVC *vc = [SaveJsonUserVC new];
    [self goToSaveVC:vc];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.open_city) {
            [m_dic setObject:self.condition.open_city.open_city_id forKey:@"open_city_id"];
        }
        if (self.condition.service_state) {
            [m_dic setObject:self.condition.service_state.item_val forKey:@"service_state"];
        }
        if (self.condition.service_name) {
            [m_dic setObject:self.condition.service_name forKey:@"service_name"];
        }
        if (self.condition.service_code) {
            [m_dic setObject:self.condition.service_code forKey:@"service_code"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryJoinUserListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppUserInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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
    
    AppUserInfo *item = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"user_id" : item.user_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_deleteJoinUserFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightFilter)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_footerView.bounds];
        btn.backgroundColor = MainColor;
        btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [btn setTitle:@"添加员工" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JsonUserCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:2];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    JsonUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[JsonUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//
//    SaveServiceVC *vc = [SaveServiceVC new];
//    vc.baseData = self.dataSource[indexPath.row];
//    [self goToSaveVC:vc];
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                [self confirmRemovingDataAtIndexPath:indexPath];
            }
                break;
                
            case 1:{
                SaveJsonUserVC *vc = [SaveJsonUserVC new];
                vc.baseData = self.dataSource[indexPath.row];
                [self goToSaveVC:vc];
            }
                break;
                
            default:
                break;
        }
    }
}


@end
