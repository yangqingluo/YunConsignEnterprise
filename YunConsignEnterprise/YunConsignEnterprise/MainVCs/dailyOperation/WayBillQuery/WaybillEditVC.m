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

- (void)goBackWithDone:(BOOL)done{
    if (done) {
        [self doDoneAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doDoneAction{
    if (self.doneBlock) {
        self.doneBlock(self.detailData);
    }
}

- (void)saveButtonAction {
    [self dismissKeyboard];
    
    if (!self.headerView.senderInfo) {
        [self showHint:@"请补全发货人信息"];
        return;
    }
    else {
        [self.toSavedata appendSenderInfo:self.headerView.senderInfo];
    }
    
    if (!self.headerView.receiverInfo) {
        [self showHint:@"请补全收货人信息"];
        return;
    }
    else {
        [self.toSavedata appendReceiverInfo:self.headerView.receiverInfo];
    }
    
    if (!self.goodsArray.count) {
        [self showHint:@"请添加货物信息"];
        return;
    }
    else {
        self.toSavedata.waybill_items = [[AppGoodsInfo mj_keyValuesArrayWithObjectArray:self.goodsArray] mj_JSONString];
    }
    
    //    long long amount = [self.toSavedata.total_amount longLongValue];
    //    long long payNowAmount = self.toSavedata.is_pay_now ? [self.toSavedata.pay_now_amount longLongValue] : 0LL;
    //    long long payOnReceiptAmount = self.toSavedata.is_pay_on_receipt ? [self.toSavedata.pay_on_receipt_amount longLongValue] : 0LL;
    //    long long payOnDeliveryAmount = self.toSavedata.is_pay_on_delivery ? [self.toSavedata.pay_on_delivery_amount longLongValue] : 0LL;
    //    if (amount != payNowAmount + payOnReceiptAmount + payOnDeliveryAmount) {
    //        [self showHint:@"总费用不等于现付提付回单付的和，请检查"];
    //        return;
    //    }
    
    self.toSavedata.consignment_time = stringFromDate(self.headerView.date, @"yyyy-MM-dd");
    [self pushUpdateWaybillFunction:@{@"waybill_id" : self.detailData.waybill_id, @"note" : @"yang_note"}];
}

- (void)pushUpdateWaybillFunction:(NSDictionary *)parm {
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_updateWaybillByIdFunction" Parm:parm completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself updateWayBillSuccess];
            }
            else {
                [weakself showHint:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)updateWayBillSuccess {
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"运单已保存" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
        [weakself goBackWithDone:YES];
    } otherButtonTitles:nil];
    [alert show];
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
    [self.headerView updateDataForWaybillDetailInfo:self.detailData];
    self.toSavedata = [AppSaveWayBillInfo mj_objectWithKeyValues:[self.detailData mj_keyValues]];
    
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
