//
//  ServiceGoodsDetailCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceGoodsDetailCell : UITableViewCell

@property (copy, nonatomic) AppServiceGoodsDetailInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
