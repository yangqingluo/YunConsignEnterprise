//
//  CodRemitWaybillDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodRemitWaybillDetailVC.h"
#import "CodLoanCheckDetailCell.h"

@interface CodRemitWaybillDetailVC ()

@end

@implementation CodRemitWaybillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.codApplyData.remittance_id.length) {
        [m_dic setObject:self.codApplyData.remittance_id forKey:@"remittance_id"];
    }
    else {
        [m_dic setObject:@"" forKey:@"remittance_id"];
        if (self.codApplyData.loan_apply_ids.length) {
            [m_dic setObject:self.codApplyData.loan_apply_ids forKey:@"loan_apply_ids"];
        }
        else if (self.codApplyData.loan_apply_id.length) {
            [m_dic setObject:self.codApplyData.loan_apply_id forKey:@"loan_apply_id"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_loan_queryWaitLoanOrLoanedWaybillListByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.selectSet removeAllObjects];
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppLoanApplyCheckWaybillInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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

#pragma mark - UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CodLoanCheckDetailCell_cell";
    CodLoanCheckDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CodLoanCheckDetailCell alloc] initWithHeaderStyle: PublicHeaderCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isChecker = self.isChecker;
    }
    id item = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    cell.data = item;
    
    //为了将文本颜色统一改为普通色
    cell.statusLabel.textColor = secondaryTextColor;
    
    return cell;
}

@end
