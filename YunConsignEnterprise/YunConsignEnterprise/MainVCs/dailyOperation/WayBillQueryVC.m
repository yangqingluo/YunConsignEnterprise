//
//  WayBillQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillQueryVC.h"

@interface WayBillQueryVC ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation WayBillQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self queryWaybillListByConditionFunction];
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

- (void)queryWaybillListByConditionFunction {
    [self showHudInView:self.view hint:nil];
    
    NSDictionary *m_dic = @{@"start_time" : @"2017-09-23", @"end_time" : @"2017-09-25", @"start" : @"0", @"limit" : @"10", @"is_cancel" : @"0"};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.items.count) {
                [weakself.dataSource addObjectsFromArray:[AppWayBillInfo mj_objectArrayWithKeyValuesArray:item.items]];
                [weakself.tableView reloadData];
            }
            
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
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

@end
