//
//  SaveCodLoanApplyFirstVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveCodLoanApplyFirstVC.h"
#import "CodLoanApplyWaybillQueryVC.h"

@interface SaveCodLoanApplyFirstVC ()

@property (strong, nonatomic) UIView *footerView;

@end

@implementation SaveCodLoanApplyFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height -= self.footerView.height;
}

- (void)setupNav {
    [self createNavWithTitle:@"申请步骤1：选择运单" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"添加", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(addWaybillButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)addWaybillButtonAction {
    CodLoanApplyWaybillQueryVC *vc = [CodLoanApplyWaybillQueryVC new];
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object){
        if ([object isKindOfClass:[AppWayBillDetailInfo class]]) {
            [weakself.dataSource addObject:object];
            [weakself.tableView reloadData];
        }
    };
    [self doPushViewController:vc animated:YES];
}

- (void)nextStepButtonAction {
    
}

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightFilter)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_footerView.bounds];
        btn.backgroundColor = MainColor;
        btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [btn setTitle:@"下一步：打款账户" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextStepButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
    }
    return _footerView;
}

@end
