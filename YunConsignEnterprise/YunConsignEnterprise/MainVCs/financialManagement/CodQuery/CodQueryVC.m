//
//  CodQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/31.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodQueryVC.h"
#import "CodQueryDetailVC.h"

static NSString *searchTimeTypeKey = @"search_time_type";

@interface CodQueryVC () {
    BOOL canSelectPaymentState;
}

@property (strong, nonatomic) AppDataDictionary *m_cod_payment_state;

@end

@implementation CodQueryVC

- (void)dealloc {
    [self.condition removeObserver:self forKeyPath:searchTimeTypeKey];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_CodQuery;
        self.condition.start_time = dateWithPriousorLaterDate(self.condition.end_time, -1);
        [self.condition addObserver:self forKeyPath:searchTimeTypeKey options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"代收款综合查询";
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"时间类型",@"subTitle":@"请选择",@"key":@"search_time_type"},
                       @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                       @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                       @{@"title":@"代收方式",@"subTitle":@"请选择",@"key":@"cash_on_delivery_type"},
                       @{@"title":@"收款状态",@"subTitle":@"请选择",@"key":@"cod_payment_state"},
                       @{@"title":@"放款状态",@"subTitle":@"请选择",@"key":@"cod_loan_state"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
    [self initialDataDictionaryForCodeArray:@[@"search_time_type", @"query_column"]];
}

- (void)searchButtonAction {
    if (!self.condition.search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    CodQueryDetailVC *vc = [CodQueryDetailVC new];
    vc.condition = [self.condition copy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"cod_payment_state"]) {
        if (!canSelectPaymentState) {
            return;
        }
    }
    [super selectRowAtIndexPath:indexPath];
}

- (void)checkDataMapExistedForCode:(NSString *)key {
    NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
    if (dataArray.count) {
        if (![self.condition valueForKey:key] && [self.toCheckDataMapSet containsObject:key]) {
            [self.condition setValue:[key isEqualToString:@"search_time_type"] ? dataArray[dataArray.count - 1] : dataArray[0] forKey:key];
            [self.tableView reloadData];
        }
    }
    else {
        [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:nil];
    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:searchTimeTypeKey]) {
        NSString *key = @"cod_payment_state";
        if ([self.condition.search_time_type.item_val integerValue] == 1) {
            canSelectPaymentState = NO;
            self.m_cod_payment_state = [self.condition valueForKey:key];
            [self.condition setValue:nil forKey:key];
        }
        else {
            canSelectPaymentState = YES;
            if (![self.condition valueForKey:key]) {
                [self.condition setValue:self.m_cod_payment_state forKey:key];
            }
        }
        [self.tableView reloadData];
    }
}

@end
