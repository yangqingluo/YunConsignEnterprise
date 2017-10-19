//
//  WaybillChangeDetailCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaybillChangeDetailCell : UITableViewCell

@property (copy, nonatomic) AppWaybillChangeInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath data:(AppWaybillChangeInfo *)m_data;

@end
