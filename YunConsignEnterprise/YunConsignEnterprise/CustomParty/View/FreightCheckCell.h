//
//  FreightCheckCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/31.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicMutableLabelView.h"

@interface FreightCheckCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (copy, nonatomic) AppCheckFreightWayBillInfo *data;

+ (NSArray *)edgeSourceArray;
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
