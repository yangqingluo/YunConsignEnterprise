//
//  TitleTextCell.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/6/14.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title;
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title titleFont:(UIFont *)titleFont;

- (void)setTitle:(NSString *)title;

@end
