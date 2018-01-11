//
//  WaybillChangeCheckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/1/11.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "WaybillChangeCheckVC.h"
#import "WaybillChangeCheckTableVC.h"
#import "PublicQueryConditionVC.h"

@interface WaybillChangeCheckVC ()

@end

@implementation WaybillChangeCheckVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewArray = [NSMutableArray new];
        [self.viewArray addObject:@{@"title":@"等待审核",@"VC":[[WaybillChangeCheckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:0]}];
        [self.viewArray addObject:@{@"title":@"审核通过",@"VC":[[WaybillChangeCheckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:1]}];
        [self.viewArray addObject:@{@"title":@"驳回",@"VC":[[WaybillChangeCheckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:2]}];
        self.condition.start_time = nil;
        self.condition.end_time = nil;
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
    vc.type = QueryConditionType_WaybillChangeCheck;
    vc.condition = self.condition;
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
