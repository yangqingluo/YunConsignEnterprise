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
    return [CodLoanApplyWaybillQueryCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:isTrue(m_data.is_can_apply) ? 4 : 3];
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

@end
