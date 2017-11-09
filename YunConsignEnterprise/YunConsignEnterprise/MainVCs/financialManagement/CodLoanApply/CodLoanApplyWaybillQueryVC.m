//
//  CodLoanApplyWaybillQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodLoanApplyWaybillQueryVC.h"

#import "CodLoanApplyWaybillQueryCell.h"

@interface CodLoanApplyWaybillQueryVC ()

@end

@implementation CodLoanApplyWaybillQueryVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = FMWaybillQueryType_CodLoanApply;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppWayBillDetailInfo *m_data = self.dataSource[indexPath.row];
    BOOL is_cash_on_delivery_causes = [m_data.cash_on_delivery_causes_amount intValue] > 0;
    BOOL is_cash_on_delivery_real = m_data.cash_on_delivery_real_time.length > 0;
    BOOL is_can_apply = isTrue(m_data.is_can_apply);
    return [CodLoanApplyWaybillQueryCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines: 2 + is_cash_on_delivery_causes + is_cash_on_delivery_real + !is_can_apply];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CodLoanApplyWaybillQuery_cell";
    CodLoanApplyWaybillQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CodLoanApplyWaybillQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = [indexPath copy];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AppWayBillDetailInfo *m_data = self.dataSource[indexPath.row];
    BOOL is_can_apply = isTrue(m_data.is_can_apply);
    if (is_can_apply) {
        self.selectedData = self.dataSource[indexPath.row];
        [self goBackWithDone:YES];
    }
}

@end
