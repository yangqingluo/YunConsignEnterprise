//
//  ServiceVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/22.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "ServiceVC.h"
#import "PublicQueryConditionVC.h"
#import "SaveServiceVC.h"
#import "ServiceLocationVC.h"
#import "TownVC.h"

#import "ServiceCell.h"

@interface ServiceVC ()

@property (strong, nonatomic) UIView *footerView;

@end

@implementation ServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
//    //查询条件所属城市默认为当前城市 2017.12.12取消该默认条件
//    AppCityInfo *city = [AppCityInfo new];
//    city.open_city_id = [[UserPublic getInstance].userData.open_city_id copy];
//    city.open_city_name = [[UserPublic getInstance].userData.open_city_name copy];
//    self.condition.open_city = city;
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height = self.footerView.top - self.tableView.top;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self beginRefreshing];
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
    vc.type = QueryConditionType_Service;
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
    SaveServiceVC *vc = [SaveServiceVC new];
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
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryServiceListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppServiceInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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
    
    AppServiceInfo *item = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"service_id" : item.service_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_deleteServiceById" Parm:m_dic completion:^(id responseBody, NSError *error){
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

- (void)pullDetailDataAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.dataSource.count - 1) {
        [self doShowHintFunction:@"数据越界"];
        return;
    }
    AppServiceInfo *item = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"service_id" : item.service_id}];
    [self doShowHudFunction:@"门店地址信息查询中..."];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryServiceById" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                AppServiceDetailInfo *detailData = [AppServiceDetailInfo mj_objectWithKeyValues:item.items[0]];
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([detailData.latitude doubleValue], [detailData.longitude doubleValue]);
                if (CLLocationCoordinate2DIsValid(coor)) {
                    ServiceLocationVC *vc = [[ServiceLocationVC alloc] initWithLocation:coor andAddress:detailData.service_address];
                    [weakself doPushViewController:vc animated:YES];
                    return;
                }
            }
            [weakself doShowHintFunction:@"地址信息有误"];
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
        [btn setTitle:@"添加门店" forState:UIControlStateNormal];
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
    return [ServiceCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    ServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ServiceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
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
//        AppServiceInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                TownVC *vc = [TownVC new];
                vc.service = self.dataSource[indexPath.row];
                [self doPushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                [self pullDetailDataAtIndexPath:indexPath];
            }
                break;
                
            case 2:{
                SaveServiceVC *vc = [SaveServiceVC new];
                vc.baseData = self.dataSource[indexPath.row];
                [self goToSaveVC:vc];
            }
                break;
                
            case 3:{
                [self confirmRemovingDataAtIndexPath:indexPath];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
