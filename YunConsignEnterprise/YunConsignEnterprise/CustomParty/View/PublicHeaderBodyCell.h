//
//  PublicHeaderBodyCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Event_PublicHeaderCellSelectButtonClicked @"Event_PublicHeaderCellSelectButtonClicked"

#define height_body_label 24.0

typedef NS_ENUM(NSInteger, PublicHeaderCellStyle) {
    PublicHeaderCellStyleDefault,
    PublicHeaderCellStyleSelection
};

@interface PublicHeaderBodyCell : UITableViewCell

@property (assign, nonatomic) PublicHeaderCellStyle headerStyle;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *baseView;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIButton *headerSelectBtn;

@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UILabel *bodyLabel1;
@property (strong, nonatomic) UILabel *bodyLabel2;
@property (strong, nonatomic) UILabel *bodyLabel3;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath bodyLabelLines:(NSUInteger)lines;
+ (CGFloat)heightForBodyWithLabelLines:(NSUInteger)lines;

- (instancetype)initWithHeaderStyle:(PublicHeaderCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setupHeader;
- (void)setupBody;
- (void)showLabel:(UILabel *)label conten:(NSString *)content;

@end
