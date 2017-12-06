//
//  FreightCheckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightCheckVC.h"
#import "FreightCheckDetailVC.h"

static NSString *searchTimeTypeKey = @"search_time_type";

@interface FreightCheckVC () {
    BOOL canSelectShowColumns;
}

@property (strong, nonatomic) NSArray *showColumnBuffer;

@end

@implementation FreightCheckVC

- (void)dealloc {
    [self.condition removeObserver:self forKeyPath:searchTimeTypeKey];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_FreightCheck;
        [self.condition addObserver:self forKeyPath:searchTimeTypeKey options:NSKeyValueObservingOptionNew context:NULL];
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
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
                       @{@"title":@"显示字段",@"subTitle":@"现付、提付、回单付",@"key":@"show_column"}];
    AppServiceInfo *serviceInfo = [AppServiceInfo mj_objectWithKeyValues:[[UserPublic getInstance].userData mj_keyValues]];
    self.condition.power_service = serviceInfo;
    [self initialDataDictionaryForCodeArray:@[@"search_time_type", @"query_column"]];
}

- (void)searchButtonAction {
    if (!self.condition.search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    
    FreightCheckDetailVC *vc = [[FreightCheckDetailVC alloc] initWithStyle:UITableViewStylePlain];
    vc.condition = self.condition;
    if (!vc.condition.show_column) {
        NSUInteger count = 3;
        NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:count];
        for (AppDataDictionary *item in [[UserPublic getInstance].dataMapDic objectForKey:@"show_column"]) {
            if (count-- > 0) {
                [m_array addObject:item];
            }
            else {
                break;
            }
        }
        vc.condition.show_column = [NSArray arrayWithArray:m_array];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"power_service"]) {
        if ([UserPublic getInstance].financeData) {
            if (!isTrue([UserPublic getInstance].financeData.is_finance)) {
                [self showHint:@"只有财务才能选择收款网点"];
                return;
            }
        }
        else {
            [self doCheckUserIsOrNotFinanceFunction:indexPath];
            return;
        }
    }
    if ([key isEqualToString:@"show_column"]) {
        if (!canSelectShowColumns) {
            return;
        }
    }
    [super selectRowAtIndexPath:indexPath];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:searchTimeTypeKey]) {
        if ([self.condition.search_time_type.item_val integerValue] == 1) {
            canSelectShowColumns = NO;
            self.showColumnBuffer = self.condition.show_column;
            self.condition.show_column = nil;
        }
        else {
            canSelectShowColumns = YES;
            if (!self.condition.show_column) {
                self.condition.show_column = self.showColumnBuffer;
            }
        }
        [self.tableView reloadData];
    }
}

@end
