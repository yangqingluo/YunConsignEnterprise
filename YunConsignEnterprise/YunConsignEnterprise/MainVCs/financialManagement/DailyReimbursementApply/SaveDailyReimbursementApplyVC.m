//
//  SaveDailyReimbursementApplyVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/6.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveDailyReimbursementApplyVC.h"
#import "PublicFMWaybillQueryVC.h"

@interface SaveDailyReimbursementApplyVC ()

@end

@implementation SaveDailyReimbursementApplyVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_DailyReimbursementSave;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = nil;
}

- (void)setupNav {
    [self createNavWithTitle:@"报销申请" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)searchButtonAction {
    [self dismissKeyboard];
    if (!self.condition.daily_name) {
        [self showHint:@"请选择报销科目"];
        return;
    }
    if ([self.condition.daily_fee intValue] < 1) {
        [self showHint:@"请输入正确的报销金额"];
        return;
    }
    [self doReimburseSaveDailyReimburseFunction];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"报销科目",@"subTitle":@"请选择",@"key":@"daily_name"},
                       @{@"title":@"报销金额",@"subTitle":@"请输入",@"key":@"daily_fee"},
                       @{@"title":@"关联运单",@"subTitle":@"请选择",@"key":@"bind_waybill_id"},
                       @{@"title":@"报销备注",@"subTitle":@"请输入",@"key":@"note"},];
    NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:@"daily_name"];
    if (dicArray.count) {
        self.condition.daily_name = dicArray[0];
    }
//    self.condition.daily_fee = @"0";
}

- (void)doReimburseSaveDailyReimburseFunction {
    [self doShowHudFunction];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"daily_name" : self.condition.daily_name.item_val, @"daily_fee" : [NSString stringWithFormat:@"%d", [self.condition.daily_fee intValue]]}];
    if (self.condition.bind_waybill_id) {
        [m_dic setObject:self.condition.bind_waybill_id forKey:@"bind_waybill_id"];
    }
    if (self.condition.note) {
        [m_dic setObject:self.condition.note forKey:@"note"];
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_reimburse_saveDailyReimburseFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself dailyReimbursementSaveSuccess];
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

- (void)dailyReimbursementSaveSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_DailyReimbursementApplyRefresh object:nil];
    [self showHint:@"保存成功"];
    [self goBackWithDone:YES];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"bind_waybill_id"]) {
        PublicFMWaybillQueryVC *vc = [PublicFMWaybillQueryVC new];
        vc.type = FMWaybillQueryType_DailyReimburse;
        QKWEAKSELF;
        vc.doneBlock = ^(NSObject *object){
            if ([object isKindOfClass:[AppWayBillDetailInfo class]]) {
                weakself.condition.bind_waybill_id = [((AppWayBillDetailInfo *)object).waybill_id copy];
                [weakself.tableView reloadData];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [super selectRowAtIndexPath:indexPath];
}

@end
