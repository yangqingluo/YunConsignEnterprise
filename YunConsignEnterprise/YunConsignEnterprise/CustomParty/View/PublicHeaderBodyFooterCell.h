//
//  PublicHeaderContentFooterCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicMutableButtonView.h"

@interface PublicHeaderBodyFooterCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *baseView;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UILabel *bodyLabel1;
@property (strong, nonatomic) UILabel *bodyLabel2;
@property (strong, nonatomic) UILabel *bodyLabel3;

@property (strong, nonatomic) PublicMutableButtonView *footerView;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setupHeader;
- (void)setupFooter;
- (void)setupBody;

@end
