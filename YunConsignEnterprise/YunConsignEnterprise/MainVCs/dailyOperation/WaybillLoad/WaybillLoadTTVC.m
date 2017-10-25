//
//  WaybillLoadTTVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLoadTTVC.h"
#import "PublicQueryConditionVC.h"

#import "PublicTTLoadFooterView.h"

@interface WaybillLoadTTVC ()

@property (strong, nonatomic) PublicTTLoadFooterView *footerView;

@end

@implementation WaybillLoadTTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height -= self.footerView.height;
    
    self.footerView.summaryView.textLabel.text = @"合计：30票/150件/货量5600";
}

- (void)setupNav {
    [self createNavWithTitle:@"运单配载" createMenuItem:^UIView *(int nIndex){
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

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnAction {
//    PublicQueryConditionVC *vc = [PublicQueryConditionVC new];
//    vc.type = QueryConditionType_WaybillLoad;
//    vc.condition = [self.condition copy];
//    QKWEAKSELF;
//    vc.doneBlock = ^(NSObject *object){
//        if ([object isKindOfClass:[AppQueryConditionInfo class]]) {
//            weakself.condition = (AppQueryConditionInfo *)object;
//            [weakself.tableView.mj_header beginRefreshing];
//        }
//    };
//    [vc showFromVC:self];
}

- (void)selectBtnAction:(UIButton *)button {
    button.selected = !button.selected;
}

#pragma mark - getter
- (PublicTTLoadFooterView *)footerView {
    if (!_footerView) {
        _footerView = [PublicTTLoadFooterView new];
        [_footerView.actionBtn setTitle:@"确定配载" forState:UIControlStateNormal];
        [_footerView.selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

@end
