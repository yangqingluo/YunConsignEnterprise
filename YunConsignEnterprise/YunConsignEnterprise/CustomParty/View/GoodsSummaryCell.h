//
//  GoodsSummaryCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldCell.h"

@interface GoodsSummaryCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *showArray;
@property (strong, nonatomic) UIView *baseView;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
