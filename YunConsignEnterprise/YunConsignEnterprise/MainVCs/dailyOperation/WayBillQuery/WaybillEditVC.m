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
    
    self.payStyleShowArray = @[@{@"title":@"现付",@"subTitle":@"请输入",@"key":@"pay_now_amount",@"subKey":@"is_pay_now"},
      @{@"title":@"提付",@"subTitle":@"请输入",@"key":@"pay_on_delivery_amount",@"subKey":@"is_pay_on_delivery"},
      @{@"title":@"回单付",@"subTitle":@"请输入",@"key":@"pay_on_receipt_amount",@"subKey":@"is_pay_on_receipt"},
      @{@"title":@"运单备注",@"subTitle":@"无",@"key":@"note"},
      @{@"title":@"内部备注",@"subTitle":@"无",@"key":@"inner_note"},
      @{@"title":@"修改原因",@"subTitle":@"无",@"key":@"change_cause"},];
    
    [self.headerView setupTitle];
    self.tableView.tableHeaderView = self.headerView;
    self.title = @"运单修改";
    [self pullWaybillDetailData:NO];
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

- (void)senderButtonAction {
    PublicSRSelectVC *vc = [PublicSRSelectVC new];
    vc.type = SRSelectType_Sender;
    vc.data = self.headerView.senderInfo;
    vc.isEditOnly = YES;
    vc.doneBlock = ^(id object){
        if ([object isKindOfClass:[AppSendReceiveInfo class]]) {
            self.headerView.senderInfo = [object copy];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)receiverButtonAction {
    if (self.detailData.start_station_city_id) {
        PublicSRSelectVC *vc = [PublicSRSelectVC new];
        vc.type = SRSelectType_Receiver;
        vc.data = self.headerView.receiverInfo;
        vc.open_city_id = self.detailData.start_station_city_id;
        vc.isEditOnly = YES;
        vc.doneBlock = ^(id object){
            if ([object isKindOfClass:[AppSendReceiveInfo class]]) {
                self.headerView.receiverInfo = [object copy];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [self pullWaybillDetailData:YES];
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
    
    if (!self.goodsArray.count) {
        [self showHint:@"请添加货物信息"];
        return;
    }
    else {
        self.toSaveData.waybill_items = [[AppGoodsInfo mj_keyValuesArrayWithObjectArray:self.goodsArray] mj_JSONString];
    }
    
    self.toSaveData.consignment_time = stringFromDate(self.headerView.date, nil);
    NSDictionary *toSaveDic = [self.toSaveData mj_keyValues];
    NSDictionary *detailDic = [self.detailData mj_keyValues];
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    [m_dic setObject:boolString(is_update_waybill_item) forKey:@"is_update_waybill_item"];
    
    BOOL hasChanged = NO;
    for (NSString *key in toSaveDic.allKeys) {
        if ([key isEqualToString:@"waybill_items"]) {
            if (is_update_waybill_item) {
                hasChanged = YES;
            }
            else {
//                continue;
            }
        }
        else if (![toSaveDic[key] isEqual:detailDic[key]]) {
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
        [self doShowHintFunction:@"未做修改"];
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
                [weakself updateWayBillSuccessWithChange:parm showMessage:item.message];
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

- (void)updateWayBillSuccessWithChange:(NSDictionary *)changedDic showMessage:(NSString *)message {
    if (changedDic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WaybillListRefresh object:nil];
        for (NSString *key in changedDic.allKeys) {
            if ([key isEqualToString:@"change_cause"] || [key isEqualToString:@"is_update_waybill_item"] || [key isEqualToString:@"waybill_items"]) {
                continue;
            }
            [self.detailData setValue:changedDic[key] forKey:key];
        }
//        QKWEAKSELF;
//        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"运单已更新" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
//            [weakself goBackWithDone:YES];
//        } otherButtonTitles:nil];
//        [alert show];
        [self doShowHintFunction:message.length ? message : @"运单已更新"];
        [self goBackWithDone:YES];
    }
    else {
        [self goBackWithDone:NO];
    }
}

- (void)pullWaybillDetailData:(BOOL)goSelectReceiver {
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
            [weakself updateSubviews:YES];
            if (goSelectReceiver) {
                [self receiverButtonAction];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)endRefreshing {
    [self doHideHudFunction];
}

- (void)updateSubviews:(BOOL)isReset {
    [self.goodsArray removeAllObjects];
    for (AppWaybillItemInfo *item in self.detailData.waybill_items) {
        AppGoodsInfo *goods = [AppGoodsInfo mj_objectWithKeyValues:[item mj_keyValues]];
        goods.goods_name = [item.waybill_item_name copy];
        [self.goodsArray addObject:goods];
    }
    [self.headerView updateDataForWaybillDetailInfo:self.detailData];
    self.toSaveData = [AppSaveWayBillInfo mj_objectWithKeyValues:[self.detailData mj_keyValues]];
    if (isReset) {
        //保证从服务器获取详情数据时的界面即时数据和服务器数据一致
        self.toSaveData.total_amount = [self.detailData.total_amount copy];
    }
    
    [self.tableView reloadData];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
//    if (indexPath.section == 0) {
//        reuseIdentifier = @"goods_title_cell";
//    }
//    WayBillTitleCell *cell = (WayBillTitleCell *)[super tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
//    if (indexPath.section == 2) {
//        cell.baseView.subTextLabel.text = [NSString stringWithFormat:@"总运费：%@", notNilString(self.toSaveData.total_amount, @"0")];
//    }
//    return cell;
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}

@end
