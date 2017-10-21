//
//  WaybillEditVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillEditVC.h"
#import "PublicSRSelectVC.h"

@interface WaybillEditVC ()

@end

@implementation WaybillEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.headerView setupTitle];
    self.tableView.tableHeaderView = self.headerView;
    self.title = @"运单修改";
    [self pullWaybillDetailData];
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
    [self.goodsArray removeAllObjects];
    for (AppWaybillItemInfo *item in self.detailData.waybill_items) {
        AppGoodsInfo *goods = [AppGoodsInfo mj_objectWithKeyValues:[item mj_keyValues]];
        goods.goods_name = [item.waybill_item_name copy];
        [self.goodsArray addObject:goods];
    }
    self.goodsSummary.freight = [self.detailData.freight longLongValue];
    self.goodsSummary.number = [self.detailData.goods_total_count intValue];
    self.goodsSummary.weight = [self.detailData.goods_total_weight doubleValue];
    self.goodsSummary.volume = [self.detailData.goods_total_volume doubleValue];
    self.headerView.titleView.textLabel.text = [NSString stringWithFormat:@"运单号/货号： %@/%@", self.detailData.waybill_number, self.detailData.goods_number];
    [self.toSavedata removeObserver:self forKeyPath:@"total_amount"];
    self.toSavedata = [AppSaveWayBillInfo mj_objectWithKeyValues:[self.detailData mj_keyValues]];
    [self.toSavedata addObserver:self forKeyPath:@"total_amount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    if (indexPath.section == 0) {
        reuseIdentifier = @"goods_title_cell";
    }
    UITableViewCell *cell = [super tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    if (indexPath.section == 2) {
        self.totalAmountLabel.text = [NSString stringWithFormat:@"总费用：%@", self.toSavedata.total_amount];
    }
    return cell;
}

@end
