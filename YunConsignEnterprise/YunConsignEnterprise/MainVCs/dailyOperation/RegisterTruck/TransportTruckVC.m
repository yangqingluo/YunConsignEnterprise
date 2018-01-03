//
//  TransportTruckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TransportTruckVC.h"
#import "TransportTruckTableVC.h"
#import "PublicQueryConditionVC.h"


@interface TransportTruckVC ()

@end

@implementation TransportTruckVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transportTruckSaveNotification:) name:kNotification_TransportTruckSaveRefresh object:nil];
        self.viewArray = [NSMutableArray new];
        [self.viewArray addObject:@{@"title":@"已登记",@"VC":[[TransportTruckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:0]}];
        [self.viewArray addObject:@{@"title":@"运输中",@"VC":[[TransportTruckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:1]}];
        [self.viewArray addObject:@{@"title":@"已完成",@"VC":[[TransportTruckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:2]}];
        self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
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

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnAction {
    PublicQueryConditionVC *vc = [PublicQueryConditionVC new];
    vc.type = QueryConditionType_TransportTruck;
    vc.condition = [self.condition copy];
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object){
        if ([object isKindOfClass:[AppQueryConditionInfo class]]) {
            weakself.condition = (AppQueryConditionInfo *)object;
            [weakself updateQueryCondition];
        }
    };
    [vc showFromVC:self];
}

#pragma mark - notification
- (void)transportTruckSaveNotification:(NSNotification *)notification {
    [self updateQueryCondition];
}

@end
