//
//  PublicDailyOpenWaybillVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicTableViewController.h"
#import "WayBillTitleCell.h"
#import "FourItemsDoubleListCell.h"
#import "GoodsSummaryCell.h"
#import "SingleInputCell.h"
#import "DoubleInputCell.h"
#import "SwitchorCell.h"
#import "SwitchedInputCell.h"

@interface PublicDailyOpenWaybillVC : AppBasicTableViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSArray *feeShowArray;
@property (strong, nonatomic) NSArray *payStyleShowArray;

@property (strong, nonatomic) NSSet *selectorSet;
@property (strong, nonatomic) NSSet *inputForSelectorSet;
@property (strong, nonatomic) NSSet *switchorSet;
@property (strong, nonatomic) NSSet *inputInvalidSet;
@property (strong, nonatomic) NSSet *defaultKeyBoardTypeSet;

@property (strong, nonatomic) IndexPathTextField *summaryFreightTextField;//物品总重量
@property (strong, nonatomic) UILabel *totalAmountLabel;//总费用

- (void)addGoodsButtonAction;
- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier;
- (UITableViewCell *)tableView:(UITableView *)tableView switchorCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier;
- (UITableViewCell *)tableView:(UITableView *)tableView singleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier;
- (UITableViewCell *)tableView:(UITableView *)tableView switchedInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier;
- (UITableViewCell *)tableView:(UITableView *)tableView doubleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier;
@end
