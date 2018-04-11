//
//  SingleShowCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/4/11.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicCellView.h"

@interface SingleShowCell : UITableViewCell

@property (strong, nonatomic) PublicCellView *baseView;
@property (assign, nonatomic) BOOL isShowBottomEdge;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath rightString:(NSString *)rightString type:(UITableViewCellAccessoryType)aType;

@end
