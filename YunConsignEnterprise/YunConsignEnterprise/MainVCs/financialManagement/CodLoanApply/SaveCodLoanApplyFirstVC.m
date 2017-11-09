//
//  SaveCodLoanApplyFirstVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveCodLoanApplyFirstVC.h"
#import "CodLoanApplyWaybillQueryVC.h"

#import "CodLoanApplyWaybillSaveCell.h"

@interface SaveCodLoanApplyFirstVC ()

@property (strong, nonatomic) UIView *footerView;

@end

@implementation SaveCodLoanApplyFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height -= self.footerView.height;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupNav {
    [self createNavWithTitle:@"申请步骤1：选择运单" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"添加", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(addWaybillButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)addWaybillButtonAction {
    CodLoanApplyWaybillQueryVC *vc = [CodLoanApplyWaybillQueryVC new];
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object){
        if ([object isKindOfClass:[AppWayBillDetailInfo class]]) {
            [weakself addWaybillData:(AppWayBillDetailInfo *)object];
        }
    };
    [self doPushViewController:vc animated:YES];
}

- (void)nextStepButtonAction {
    
}

- (void)addWaybillData:(AppWayBillDetailInfo *)data {
    for (AppWayBillDetailInfo *m_data in self.dataSource) {
        if ([m_data.waybill_id isEqualToString:data.waybill_id]) {
            return;
        }
    }
    [self.dataSource addObject:data];
    [self.tableView reloadData];
}

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightFilter)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_footerView.bounds];
        btn.backgroundColor = MainColor;
        btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [btn setTitle:@"下一步：打款账户" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextStepButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppWayBillDetailInfo *m_data = self.dataSource[indexPath.row];
    BOOL is_cash_on_delivery_causes = [m_data.cash_on_delivery_causes_amount intValue] > 0;
    BOOL is_cash_on_delivery_real = m_data.cash_on_delivery_real_time.length > 0;
    return [CodLoanApplyWaybillSaveCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines: 2 + is_cash_on_delivery_causes + is_cash_on_delivery_real];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CodLoanApplyWaybillSave_cell";
    CodLoanApplyWaybillSaveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CodLoanApplyWaybillSaveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = [indexPath copy];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
