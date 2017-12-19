//
//  DailyReimbursementCheckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyReimbursementCheckVC.h"
#import "DailyReimbursementCheckTableVC.h"
#import "PublicQueryConditionVC.h"

@interface DailyReimbursementCheckVC ()

@end

@implementation DailyReimbursementCheckVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewArray = [NSMutableArray new];
        [self.viewArray addObject:@{@"title":@"等待审核",@"VC":[[DailyReimbursementCheckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:0]}];
        [self.viewArray addObject:@{@"title":@"审核通过",@"VC":[[DailyReimbursementCheckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:1]}];
        [self.viewArray addObject:@{@"title":@"驳回",@"VC":[[DailyReimbursementCheckTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:2]}];
        self.condition.is_match_waybill = @"1";
        self.condition.start_time = nil;
        self.condition.end_time = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    vc.type = QueryConditionType_DailyReimbursementCheck;
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

@end
