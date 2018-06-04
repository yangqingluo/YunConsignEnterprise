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
    
    self.feeShowArray = @[@{@"title":@"回单",@"subTitle":@"请选择",@"key":@"receipt_sign_type"},
                      @{@"title":@"代收款",@"subTitle":@"请选择",@"key":@"cash_on_delivery_type"},
                      @{@"title":@"代收款金额",@"subTitle":@"请输入",@"key":@"cash_on_delivery_amount"},
                      @{@"title":@"运费代扣",@"subTitle":@"请选择",@"key":@"is_deduction_freight"},
                      @{@"title":@"是否送货",@"subTitle":@"请选择",@"key":@"is_deliver_goods"},
                      @[@{@"title":@"叉车费",@"subTitle":@"请输入",@"key":@"forklift_fee"},
                        @{@"title":@"回扣费",@"subTitle":@"请输入",@"key":@"rebate_fee"}],
                      @[@{@"title":@"保价",@"subTitle":@"请输入",@"key":@"insurance_amount"},
                        @{@"title":@"保价费",@"subTitle":@"根据报价数目生成",@"key":@"insurance_fee"}],
                      @[@{@"title":@"接货费",@"subTitle":@"请输入",@"key":@"take_goods_fee"},
                        @{@"title":@"送货费",@"subTitle":@"请输入",@"key":@"deliver_goods_fee"}],
                      @[@{@"title":@"中转费",@"subTitle":@"请输入",@"key":@"transfer_fee"},
                        @{@"title":@"垫付费",@"subTitle":@"请输入",@"key":@"pay_for_sb_fee"}],
                      @{@"title":@"原返费",@"subTitle":@"请输入",@"key":@"return_fee"},
                      @{@"title":@"原返运单",@"subTitle":@"无",@"key":@"goods_number"},];
    
    self.payStyleShowArray = @[@{@"title":@"现付",@"subTitle":@"请输入",@"key":@"pay_now_amount",@"subKey":@"is_pay_now"},
                               @{@"title":@"提付",@"subTitle":@"请输入",@"key":@"pay_on_delivery_amount",@"subKey":@"is_pay_on_delivery"},
                               @{@"title":@"回单付",@"subTitle":@"请输入",@"key":@"pay_on_receipt_amount",@"subKey":@"is_pay_on_receipt"},
                               @{@"title":@"运单备注",@"subTitle":@"无",@"key":@"note"},
                               @{@"title":@"内部备注",@"subTitle":@"无",@"key":@"inner_note"},
                               @{@"title":@"修改原因",@"subTitle":@"无",@"key":@"change_cause"},];
    
    self.tableView.tableHeaderView = self.headerView;
    self.title = @"原货返回";
    [self pullWaybillDetailData:NO];
}

- (void)goBackWithDone:(BOOL)done{
    if (done) {
        [self doDoneAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doDoneAction {
    if (self.doneBlock) {
        self.doneBlock(self.detailData);
    }
}

- (void)receiverButtonAction {
    if (self.detailData.end_station_city_id) {
        PublicSRSelectVC *vc = [PublicSRSelectVC new];
        vc.type = SRSelectType_Receiver;
        vc.data = self.headerView.receiverInfo;
        vc.open_city_id = self.detailData.end_station_city_id;
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

- (void)pushSaveWaybillFunction:(NSDictionary *)parm {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_saveWaybillFunction" Parm:parm completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1 && item.items.count) {
                AppSaveBackWayBillInfo *info = [AppSaveBackWayBillInfo mj_objectWithKeyValues:item.items[0]];
                [weakself saveWayBillSuccess:info];
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

- (void)saveWayBillSuccess:(AppSaveBackWayBillInfo *)info {
//    QKWEAKSELF;
//    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"运单已保存" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
//        [weakself goBackWithDone:YES];
//    } otherButtonTitles:nil];
//    [alert show];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WaybillReceiveRefresh object:nil];
    [self showHint:@"原货返回成功"];
    [self goBackWithDone:YES];
}

- (void)pullWaybillDetailData:(BOOL)goSelectReceiver {
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"waybill_id" : self.baseData.waybill_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.detailData = [AppWayBillDetailInfo mj_objectWithKeyValues:item.items[0]];
                weakself.detailData.return_fee = [weakself.detailData.freight copy];
                weakself.detailData.return_waybill_id = [weakself.baseData.waybill_id copy];
                weakself.detailData.return_waybill_number = [weakself.baseData.waybill_number copy];
            }
            [weakself updateSubviews];
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

- (void)updateSubviews {
    [self.goodsArray removeAllObjects];
    for (AppWaybillItemInfo *item in self.detailData.waybill_items) {
        AppGoodsInfo *goods = [AppGoodsInfo mj_objectWithKeyValues:[item mj_keyValues]];
        goods.goods_name = [item.waybill_item_name copy];
        [self.goodsArray addObject:goods];
    }
    [self.headerView updateDataForWaybillDetailInfo:self.detailData isReturn:YES];
    self.headerView.date = [NSDate date];
    self.toSaveData = [AppSaveReturnWayBillInfo mj_objectWithKeyValues:[self.detailData mj_keyValues]];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    if (indexPath.section == 0) {
        reuseIdentifier = @"goods_title_cell";
    }
    WayBillTitleCell *cell = (WayBillTitleCell *)[super tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
//    if (indexPath.section == 2) {
//        cell.baseView.subTextLabel.text = [NSString stringWithFormat:@"总运费：%@", notNilString(self.toSaveData.total_amount, @"0")];
//    }
    return cell;
}

#pragma mark - UITableView
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView singleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SingleInputCell *cell = (SingleInputCell *)[super tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    NSString *key = showObject[@"key"];
    if ([key isEqualToString:@"goods_number"]) {
        cell.baseView.textField.enabled = NO;
        cell.baseView.textField.adjustZeroShow = NO;
    }
    else if ([key isEqualToString:@"return_fee"]) {
        cell.baseView.textField.enabled = NO;
//        cell.baseView.textField.adjustZeroShow = NO;
    }
    return cell;
}

@end
