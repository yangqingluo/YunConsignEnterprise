//
//  CodCheckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodCheckVC.h"
#import "CodCheckDetailVC.h"

@interface CodCheckVC ()

@property (strong, nonatomic) AppCheckUserFinanceInfo *financeData;

@end

@implementation CodCheckVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_CodQuery;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.accessInfo.menu_name;
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"时间类型",@"subTitle":@"请选择",@"key":@"search_time_type"},
                       @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                       @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                       @{@"title":@"收款网点",@"subTitle":@"请选择",@"key":@"power_service"},
                       @{@"title":@"代收方式",@"subTitle":@"请选择",@"key":@"cash_on_delivery_type"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
    [self checkDataMapExistedForCode:@"search_time_type"];
    [self checkDataMapExistedForCode:@"query_column"];
}

- (void)searchButtonAction {
    if (!self.condition.search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    CodCheckDetailVC *vc = [[CodCheckDetailVC alloc] initWithStyle:UITableViewStylePlain];
    vc.condition = [self.condition copy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"power_service"]) {
        if (self.financeData) {
            if (!isTrue(self.financeData.is_finance)) {
                [self showHint:@"只有财务才能选择收款网点"];
                return;
            }
        }
        else {
            [self doCheckUserIsOrNotFinanceFunction:indexPath];
            return;
        }
    }
    
    [super selectRowAtIndexPath:indexPath];
}

- (void)doCheckUserIsOrNotFinanceFunction:(NSIndexPath *)indexPath {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_checkUserIsOrNotFinanceFunction" Parm:nil completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            if ([responseBody isKindOfClass:[ResponseItem class]]) {
                ResponseItem *item = (ResponseItem *)responseBody;
                if (item.items.count) {
                    weakself.financeData = [AppCheckUserFinanceInfo mj_objectWithKeyValues:item.items[0]];
                    [weakself selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

@end
