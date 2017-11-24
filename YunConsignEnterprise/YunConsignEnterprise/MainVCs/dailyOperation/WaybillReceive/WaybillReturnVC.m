//
//  WaybillReturnVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillReturnVC.h"
#import "PublicSRSelectVC.h"

@interface WaybillReturnVC ()

@end

@implementation WaybillReturnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payStyleShowArray = @[@{@"title":@"现付",@"subTitle":@"0",@"key":@"pay_now_amount",@"subKey":@"is_pay_now"},
                               @{@"title":@"提付",@"subTitle":@"0",@"key":@"pay_on_delivery_amount",@"subKey":@"is_pay_on_delivery"},
                               @{@"title":@"回单付",@"subTitle":@"0",@"key":@"pay_on_receipt_amount",@"subKey":@"is_pay_on_receipt"},
                               @{@"title":@"运单备注",@"subTitle":@"无",@"key":@"note"},
                               @{@"title":@"内部备注",@"subTitle":@"无",@"key":@"inner_note"},
                               @{@"title":@"修改原因",@"subTitle":@"无",@"key":@"change_cause"},];
    
    [self.headerView setupTitle];
    self.tableView.tableHeaderView = self.headerView;
    self.title = @"原货返回";
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
        [self.toSaveData appendSenderInfo:self.headerView.senderInfo];
    }
    
    if (!self.headerView.receiverInfo) {
        [self showHint:@"请补全收货人信息"];
        return;
    }
    else {
        [self.toSaveData appendReceiverInfo:self.headerView.receiverInfo];
    }
    
    //    if (!self.goodsArray.count) {
    //        [self showHint:@"请添加货物信息"];
    //        return;
    //    }
    //    else {
    //        self.toSavedata.waybill_items = [[AppGoodsInfo mj_keyValuesArrayWithObjectArray:self.goodsArray] mj_JSONString];
    //    }
    
    //    long long amount = [self.toSavedata.total_amount longLongValue];
    //    long long payNowAmount = self.toSavedata.is_pay_now ? [self.toSavedata.pay_now_amount longLongValue] : 0LL;
    //    long long payOnReceiptAmount = self.toSavedata.is_pay_on_receipt ? [self.toSavedata.pay_on_receipt_amount longLongValue] : 0LL;
    //    long long payOnDeliveryAmount = self.toSavedata.is_pay_on_delivery ? [self.toSavedata.pay_on_delivery_amount longLongValue] : 0LL;
    //    if (amount != payNowAmount + payOnReceiptAmount + payOnDeliveryAmount) {
    //        [self showHint:@"总费用不等于现付提付回单付的和，请检查"];
    //        return;
    //    }
    
    self.toSaveData.consignment_time = stringFromDate(self.headerView.date, @"yyyy-MM-dd");
    NSDictionary *toSaveDic = [self.toSaveData mj_keyValues];
    NSDictionary *detailDic = [self.detailData mj_keyValues];
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    
    BOOL hasChanged = NO;
    for (NSString *key in toSaveDic.allKeys) {
        if ([key isEqualToString:@"waybill_items"]) {
            continue;
        }
        if (![toSaveDic[key] isEqual:detailDic[key]]) {
            hasChanged = YES;
        }
        [m_dic setObject:toSaveDic[key] forKey:key];
    }
    if (hasChanged) {
        //        NSLog(@"%@", [AppPublic logDic:m_dic]);
        [m_dic setObject:self.detailData.waybill_id forKey:@"waybill_id"];
        [self pushUpdateWaybillFunction:m_dic];
    }
    else {
        [self updateWayBillSuccessWithChange:nil];
    }
}

- (void)pushUpdateWaybillFunction:(NSDictionary *)parm {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_updateWaybillByIdFunction" Parm:parm completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself updateWayBillSuccessWithChange:parm];
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

- (void)updateWayBillSuccessWithChange:(NSDictionary *)changedDic {
    if (changedDic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WaybillReceiveRefresh object:nil];
        for (NSString *key in changedDic.allKeys) {
            if ([key isEqualToString:@"change_cause"]) {
                continue;
            }
            [self.detailData setValue:changedDic[key] forKey:key];
        }
        QKWEAKSELF;
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"运单已更新" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
            [weakself goBackWithDone:YES];
        } otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self goBackWithDone:NO];
    }
}

- (void)pullWaybillDetailData {
    [self doShowHudFunction];
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
    [self doHideHudFunction];
}

- (void)updateSubviews {
    [self.goodsArray removeAllObjects];
    for (AppWaybillItemInfo *item in self.detailData.waybill_items) {
        AppGoodsInfo *goods = [AppGoodsInfo mj_objectWithKeyValues:[item mj_keyValues]];
        goods.goods_name = [item.waybill_item_name copy];
        [self.goodsArray addObject:goods];
    }
    [self.headerView updateDataForWaybillDetailInfo:self.detailData isReturn:YES];
    self.toSaveData = [AppSaveWayBillInfo mj_objectWithKeyValues:[self.detailData mj_keyValues]];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    if (indexPath.section == 0) {
        reuseIdentifier = @"goods_title_cell";
    }
    WayBillTitleCell *cell = (WayBillTitleCell *)[super tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    if (indexPath.section == 2) {
        cell.baseView.subTextLabel.text = [NSString stringWithFormat:@"总运费：%@", self.toSaveData.total_amount];
    }
    return cell;
}

@end
