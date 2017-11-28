//
//  DailyReimbursementApplyTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyReimbursementApplyTableVC.h"
#import "SaveDailyReimbursementApplyVC.h"
#import "PublicDailyReimbursementDetailVC.h"

#import "DailyReimbursementApplyCell.h"
#import "PublicFooterSummaryView.h"

@interface DailyReimbursementApplyTableVC ()

@property (strong, nonatomic) UIView *footerView;

@end

@implementation DailyReimbursementApplyTableVC

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(AppBasicViewController *)pVC andIndexTag:(NSInteger)index {
//    self = [super initWithStyle:style parentVC:pVC andIndexTag:index];
//    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_DailyReimbursementApplyRefresh object:nil];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.top = 0;
    if (self.indextag != 2) {
        self.footerView.bottom = self.view.height;
        [self.view addSubview:self.footerView];
        self.footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.tableView.height = self.footerView.top - self.tableView.top;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    else {
        self.tableView.height = self.view.height;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"daily_apply_state" : [NSString stringWithFormat:@"%d", (int)self.indextag + 1], @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
        if (self.condition.daily_name) {
            [m_dic setObject:self.condition.daily_name.item_val forKey:@"daily_name"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_reimburse_queryDailyReimburseListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppDailyReimbursementApplyInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakself updateTableViewFooter];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)doReimburseDeleteDailyReimburseFunction:(NSString *)daily_apply_id{
    if (!daily_apply_id) {
        return;
    }
    [self doShowHudFunction];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"daily_apply_id" : daily_apply_id}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_reimburse_deleteDailyReimburseFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself dailyReimbursementDeleteSuccess:@"取消成功"];
            }
            else {
                [weakself doShowHintFunction:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)applyButtonAction {
    SaveDailyReimbursementApplyVC *vc = [SaveDailyReimbursementApplyVC new];
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object){
        [weakself.tableView.mj_header beginRefreshing];
    };
    [self doPushViewController:vc animated:YES];
}

- (void)updateSubviews {
    if (self.indextag == 1) {
        int daily_fee = 0;
        for (AppDailyReimbursementApplyInfo *item in self.dataSource) {
            daily_fee += [item.daily_fee intValue];
        }
        ((PublicFooterSummaryView *)self.footerView).textLabel.text = [NSString stringWithFormat:@"已打款总金额：%d", daily_fee];
    }
    [self.tableView reloadData];
}

- (void)dailyReimbursementDeleteSuccess:(NSString *)hint {
    [self doShowHintFunction:hint];
    [self beginRefreshing];
}

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        switch (self.indextag) {
            case 0:{
                _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightFilter)];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:_footerView.bounds];
                btn.backgroundColor = MainColor;
                btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
                [btn setTitle:@"报销申请" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(applyButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [_footerView addSubview:btn];
            }
                break;
                
            case 1:{
                _footerView = [[PublicFooterSummaryView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
                _footerView.backgroundColor = [UIColor clearColor];
            }
                break;
                
            default:
                break;
        }
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDailyReimbursementApplyInfo *item = self.dataSource[indexPath.row];
    return [DailyReimbursementApplyCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:(self.indextag == 0 ? 2 : 3) + (item.note.length > 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DailyReimbursementApply_cell";
    DailyReimbursementApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DailyReimbursementApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indextag = self.indextag;
    }
    cell.data = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PublicDailyReimbursementDetailVC *vc = [PublicDailyReimbursementDetailVC new];
    vc.applyData = self.dataSource[indexPath.row];
    [self doPushViewController:vc animated:YES];
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        AppDailyReimbursementApplyInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                if (self.indextag == 0) {
                    //取消申请
                    QKWEAKSELF;
                    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定取消申请吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakself doReimburseDeleteDailyReimburseFunction:item.daily_apply_id];
                        }
                    } otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                else {
                    //查看凭证
                    if (item.voucher.length) {
                        NSArray *m_array = [item.voucher componentsSeparatedByString:@","];
                        [[PublicMessageReadManager defaultManager] showBrowserWithImages:m_array currentPhotoIndex:0];
                    }
                    else {
                        [self doShowHintFunction:@"凭证不存在"];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}

@end
