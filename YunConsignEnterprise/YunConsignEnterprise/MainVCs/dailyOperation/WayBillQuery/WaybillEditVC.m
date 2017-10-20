//
//  WaybillEditVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillEditVC.h"
#import "PublicSRSelectVC.h"

#import "WaybillEditHeaderView.h"

@interface WaybillEditVC ()

@property (strong, nonatomic) WaybillEditHeaderView *headerView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation WaybillEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
    [self pullWaybillDetailData];
}

- (void)setupNav {
    [self createNavWithTitle:@"运单修改" createMenuItem:^UIView *(int nIndex){
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
    PublicSRSelectVC *vc = [PublicSRSelectVC new];
    vc.type = SRSelectType_Sender;
    vc.doneBlock = ^(id object){
        if ([object isKindOfClass:[AppSendReceiveInfo class]]) {
            
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)receiverButtonAction {
//    PublicSRSelectVC *vc = [PublicSRSelectVC new];
//    vc.type = SRSelectType_Receiver;
//    vc.doneBlock = ^(id object){
//        if ([object isKindOfClass:[AppSendReceiveInfo class]]) {
//            self.headerView.receiverInfo = [object copy];
//        }
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveButtonAction {
    
}

- (void)pullWaybillDetailData {
    [self showHudInView:self.view hint:nil];
    NSDictionary *m_dic = @{@"waybill_id" : self.detailData.waybill_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.detailData = [AppWayBillDetailInfo mj_objectWithKeyValues:item.items[0]];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)endRefreshing {
    [self hideHud];
}

- (void)updateSubviews {
    self.headerView.detailData = self.detailData;
    [self.tableView reloadData];
}

#pragma mark - getter
- (WaybillEditHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [WaybillEditHeaderView new];
        [_headerView.senderButton addTarget:self action:@selector(senderButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.receiverButton addTarget:self action:@selector(receiverButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightMiddle)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_footerView.bounds];
        btn.backgroundColor = MainColor;
        btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [btn setTitle:@"保存运单" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
    }
    return _footerView;
}

@end
