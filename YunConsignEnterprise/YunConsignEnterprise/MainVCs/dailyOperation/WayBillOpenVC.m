//
//  WayBillOpenVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillOpenVC.h"
#import "PublicSRSelectVC.h"
#import "AddGoodsVC.h"

#import "WayBillSRHeaderView.h"
#import "WayBillTitleCell.h"

@interface WayBillOpenVC ()

@property (strong, nonatomic) WayBillSRHeaderView *headerView;
@property (strong, nonatomic) NSMutableArray *goodsArray;

@end

@implementation WayBillOpenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)senderButtonAction {
    PublicSRSelectVC *vc = [PublicSRSelectVC new];
    vc.type = SRSelectType_Sender;
    vc.doneBlock = ^(id object){
        if ([object isKindOfClass:[AppSendReceiveInfo class]]) {
            self.headerView.senderInfo = [object copy];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)receiverButtonAction {
    PublicSRSelectVC *vc = [PublicSRSelectVC new];
    vc.type = SRSelectType_Receiver;
    vc.doneBlock = ^(id object){
        if ([object isKindOfClass:[AppSendReceiveInfo class]]) {
            self.headerView.receiverInfo = [object copy];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addGoodsButtonAction {
    if (!self.headerView.senderInfo) {
        [self showHint:@"请补全发货人信息"];
        return;
    }
    AddGoodsVC *vc = [AddGoodsVC new];
    vc.senderInfo = [self.headerView.senderInfo copy];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
- (WayBillSRHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WayBillSRHeaderView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 160)];
        [_headerView.senderButton addTarget:self action:@selector(senderButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.receiverButton addTarget:self action:@selector(receiverButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray new];
    }
    return _goodsArray;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rows = 0;
    switch (section) {
        case 0:{
            rows = 1 + 1 + self.goodsArray.count;
        }
            break;
            
        default:
            break;
    }
    return rows;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return kEdgeMiddle;
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeight;
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                
            }
            else {
                if (self.goodsArray.count == 0) {
                    rowHeight = 114.0;
                }
                else {
                    
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    
    return rowHeight;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0){
//        return nil;
//    }
//    
//    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:[UIColor whiteColor]];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, screen_width - 2 * kEdge, kCellHeight)];
//    label.font = [UIFont systemFontOfSize:16.0];
//    
//    if (section == 1) {
//        label.text = @"应用管理";
//    }
//    else if (section == 2) {
//        label.text = @"统计报表";
//    }
//    
//    [contentView addSubview:label];
//    return contentView;
//}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"goods_cell";
                WayBillTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[WayBillTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIButton *addGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 100, 0, 120, kCellHeight)];
                    [addGoodsBtn setImage:[UIImage imageNamed:@"list_icon_add"] forState:UIControlStateNormal];
                    [addGoodsBtn setTitle:@"  添加" forState:UIControlStateNormal];
                    [addGoodsBtn setTitleColor:MainColor forState:UIControlStateNormal];
                    addGoodsBtn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
                    [addGoodsBtn addTarget:self action:@selector(addGoodsButtonAction) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:addGoodsBtn];
                }
                
                cell.textLabel.text = @"货物信息";
                
                return cell;
            }
            else {
                if (self.goodsArray.count == 0) {
                    static NSString *CellIdentifier = @"no_goods_cell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.textColor = secondaryTextColor;
                        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
                    }
                    
                    cell.textLabel.text = @"尚未添加货物";
                    
                    return cell;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    static NSString *CellIdentifier = @"wayBill_cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
    }
//
//    cell.tag = indexPath.section;
//    cell.data = self.showArrays[indexPath.section];
//    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
