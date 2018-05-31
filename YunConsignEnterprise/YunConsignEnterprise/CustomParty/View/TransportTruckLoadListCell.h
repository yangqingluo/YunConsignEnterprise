//
//  TransportTruckLoadListCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Event_TransportTruckLoadListCellClicked @"Event_TransportTruckLoadListCellClicked"

@interface TransportTruckLoadListCell : UITableViewCell

@property (copy, nonatomic) NSArray *dataArray;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath dataArray:(NSArray *)m_array;

@end
