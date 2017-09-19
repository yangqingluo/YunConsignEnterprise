//
//  WayBillOpenVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillOpenVC.h"

#import "WayBillSRHeaderView.h"

@interface WayBillOpenVC ()

@property (strong, nonatomic) WayBillSRHeaderView *headerView;

@end

@implementation WayBillOpenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
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

- (void)senderButtonAction {
    if (self.headerView.senderInfo) {
        self.headerView.senderInfo = nil;
    }
    else {
        AppSendReceiveInfo *senderInfo = [AppSendReceiveInfo mj_objectWithKeyValues:@{@"customer" : @{
                                                                                              @"freight_cust_name" : @"张三",
                                                                                              @"phone": @"13980808080",
                                                                                              @"last_deliver_time": @"2017-08-02" ,
                                                                                              @"last_deliver_goods": @"杯子/12/0/1"
                                                                                              },
                                                                                      @"service" : @{
                                                                                              @"open_city_id": @"1",
                                                                                              @"open_city_name": @"成都",
                                                                                              @"service_id": @"1",
                                                                                              @"service_name": @"五块石店"
                                                                                              }}];
        self.headerView.senderInfo = senderInfo;
    }
}

#pragma mark - getter
- (WayBillSRHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WayBillSRHeaderView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 160)];
        [_headerView.senderButton addTarget:self action:@selector(senderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

#pragma mark - UITableView
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return kEdgeMiddle;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0){
//        return 0.01;
//    }
//    else{
//        return kCellHeight;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [CheeseBoardCell tableView:tableView heightForRowAtIndexPath:indexPath withData:self.showArrays[indexPath.section]];
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0){
//        return nil;
//    }
//    
//    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:[UIColor whiteColor]];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, screen_width - 2 * kEdge, kCellHeight)];
//    label.font = [UIFont systemFontOfSize:16.0];
//    
//    if (section == 1) {
//        label.text = @"应用管理";
//    }
//    else if (section == 2) {
//        label.text = @"统计报表";
//    }
//    
//    [contentView addSubview:label];
//    return contentView;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"work_cell";
//    CheeseBoardCell *cell = (CheeseBoardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell) {
//        cell = [[CheeseBoardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//    }
//    
//    cell.tag = indexPath.section;
//    cell.data = self.showArrays[indexPath.section];
//    
//    return cell;
//}

@end
