//
//  PublicFMWaybillQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicFMWaybillQueryVC.h"

#import "PublicInputHeaderView.h"

@interface PublicFMWaybillQueryVC ()

@property (strong, nonatomic) PublicInputHeaderView *headerView;

@end

@implementation PublicFMWaybillQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.headerView];
    self.tableView.top = self.headerView.bottom;
    self.tableView.height = self.view.height - self.headerView.bottom;
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : @"查询运单" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)cancelButtonAction {
    [self goBackWithDone:NO];
}

- (void)searchButtonAction {
    [self goBackWithDone:YES];
}

- (void)goBackWithDone:(BOOL)done {
    if (done) {
        [self doDoneAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doDoneAction {
    if (self.doneBlock) {
//        self.doneBlock(self.condition);
    }
}

#pragma mark - getter
- (PublicInputHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PublicInputHeaderView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom + kEdge, screen_width, kCellHeightFilter)];
        _headerView.baseView.textLabel.text = @"运单号/货号";
        _headerView.baseView.textField.placeholder = @"请输入运单号或货号";
        _headerView.baseView.textField.keyboardType = UIKeyboardTypeURL;
        [_headerView.baseView adjustSubviews];
    }
    return _headerView;
}

@end
