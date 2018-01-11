//
//  WaybillChangeCheckTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/1/11.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "WaybillChangeCheckTableVC.h"
#import "PublicWaybillDetailVC.h"

#import "WaybillChangeCheckCell.h"

@interface WaybillChangeCheckTableVC ()<UITextFieldDelegate>

@end

@implementation WaybillChangeCheckTableVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(AppBasicViewController *)pVC andIndexTag:(NSInteger)index {
    self = [super initWithStyle:style parentVC:pVC andIndexTag:index];
    if (self) {
        switch (index) {
            case 1: {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_WaybillChangeCheckedRefresh object:nil];
            }
                break;
                
            case 2: {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_WaybillChangeCheckRejectRefresh object:nil];
            }
                break;
                
            default:
                break;
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.top = 0;
    self.tableView.height = self.view.height;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"change_state" : [NSString stringWithFormat:@"%d", (int)self.indextag + 1], @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
    }
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillChangeCheckListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppWaybillChangeApplyInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakself updateTableViewFooter];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)doCheckWaybillChangeByIdFunction:(NSString *)change_id {
    if (!change_id) {
        return;
    }
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"change_id" : change_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_checkWaybillChangeByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself checkWaybillChangeSuccess];
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

- (void)doRejectWaybillChangeByIdFunction:(NSString *)change_id cause:(NSString *)check_note {
    if (!change_id) {
        return;
    }
    if (!check_note.length) {
        [self doShowHintFunction:@"请输入驳回原因"];
        return;
    }
    
    [self doShowHudFunction];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"change_id" : change_id}];
    if (check_note) {
        [m_dic setObject:check_note forKey:@"check_note"];
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_rejectWaybillChangeByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself rejectWaybillChangeSuccess];
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

- (void)checkWaybillChangeSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WaybillChangeCheckedRefresh object:nil];
    [self doShowHintFunction:@"审核通过"];
    [self beginRefreshing];
}

- (void)rejectWaybillChangeSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WaybillChangeCheckRejectRefresh object:nil];
    [self doShowHintFunction:@"驳回成功"];
    [self beginRefreshing];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WaybillChangeCheckCell tableView:tableView heightForRowAtIndexPath:indexPath data:self.dataSource[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    WaybillChangeCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[WaybillChangeCheckCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    return cell;
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        AppWaybillChangeApplyInfo *item = self.dataSource[indexPath.row];
        int tag = ([item.change_state integerValue] == WAYBILL_CHANGE_APPLY_STATE_1 ? 2 : 0) - [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                PublicWaybillDetailVC *vc = [PublicWaybillDetailVC new];
                vc.data = item;
                [self doPushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                //驳回
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定驳回申请吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        UITextField *textField = [view textFieldAtIndex:0];
                        [weakself doRejectWaybillChangeByIdFunction:item.change_id cause:textField.text];
                    }
                }otherButtonTitles:@"确定", nil];
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField *alertTextField = [alert textFieldAtIndex:0];
                alertTextField.clearButtonMode = UITextFieldViewModeAlways;
                alertTextField.returnKeyType = UIReturnKeyDone;
                alertTextField.delegate = self;
                alertTextField.placeholder = @"驳回原因";
                [alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [alert show];
            }
                break;
                
            case 2:{
                //审核通过
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定通过审核吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [weakself doCheckWaybillChangeByIdFunction:item.change_id];
                    }
                } otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
