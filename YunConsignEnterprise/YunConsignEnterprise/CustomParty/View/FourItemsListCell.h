//
//  FourItemsListCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourItemsListCell : UITableViewCell

@property (strong, nonatomic) UILabel *firstLeftLabel;
@property (strong, nonatomic) UILabel *firstRightLabel;
@property (strong, nonatomic) UILabel *secondLeftLabel;
@property (strong, nonatomic) UILabel *secondRightLabel;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
