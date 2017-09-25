//
//  WayBillCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WayBillCell : UITableViewCell

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UIView *footerView;


@property (copy, nonatomic) AppWayBillInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
