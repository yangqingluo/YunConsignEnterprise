//
//  CodRemitVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodRemitVC.h"
#import "CodRemitTableVC.h"
#import "PublicQueryConditionVC.h"

@interface CodRemitVC ()

@end

@implementation CodRemitVC

- (instancetype)init {
    self = [super init];
    if (self) {
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transportTruckSaveNotification:) name:kNotification_TransportTruckSaveRefresh object:nil];
        self.viewArray = [NSMutableArray new];
        [self.viewArray addObject:@{@"title":@"等待打款",@"VC":[[CodRemitTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:0]}];
        [self.viewArray addObject:@{@"title":@"已打款",@"VC":[[CodRemitTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:1]}];
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
    vc.type = QueryConditionType_CodRemit;
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


@end
