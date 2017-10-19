//
//  WayBillDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillDetailVC.h"

#import "MJRefresh.h"
#import "PublicMutableButtonView.h"
#import "WayBillDetailHeaderView.h"

@interface WayBillDetailVC ()

@property (strong, nonatomic) WayBillDetailHeaderView *headerView;
@property (strong, nonatomic) PublicMutableButtonView *footerView;

@property (copy, nonatomic) AppWayBillDetailInfo *detailData;

@end

@implementation WayBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
    self.footerView.bottom = self.view.height;
    self.footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.footerView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"运单详情" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewRightButton([UIImage imageNamed:@"navbar_icon_edit"], nil);
            [btn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editBtnAction {
    
}

- (void)pullWaybillDetailData {
    NSDictionary *m_dic = @{@"waybill_id" : self.data.waybill_id};
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

- (void)updateTableViewHeader {
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself pullWaybillDetailData];
    }];
}

- (void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)updateSubviews {
    [self.tableView reloadData];
    self.headerView.data = [self.detailData copy];
}

#pragma mark - getter
- (WayBillDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [WayBillDetailHeaderView new];
    }
    return _headerView;
}

- (PublicMutableButtonView *)footerView {
    if (!_footerView) {
        _footerView = [[PublicMutableButtonView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
        _footerView.defaultWidthScale = 1.0 / 4;
        [_footerView updateDataSourceWithArray:@[@"作废", @"打印", @"修改记录", @"物流跟踪"]];
        for (UIButton *btn in _footerView.showViews) {
            btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
            if ([_footerView.showViews indexOfObject:btn] == 0) {
                btn.backgroundColor = EmphasizedColor;
                [btn setTitleColor:WarningColor forState:UIControlStateNormal];
            }
            else {
                btn.backgroundColor = MainColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    return _footerView;
}


@end
