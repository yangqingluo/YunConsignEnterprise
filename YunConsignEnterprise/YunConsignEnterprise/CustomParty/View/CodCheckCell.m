//
//  CodCheckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodCheckCell.h"

@implementation CodCheckCell

#pragma mark - setter
- (void)setData:(AppWayBillDetailInfo *)data {
    _data = data;
    
    NSMutableArray *m_array = [NSMutableArray new];
    [m_array addObject:[NSString stringWithFormat:@"%d", (int)self.indexPath.row + 1]];
    [m_array addObject:data.goods_number];
    [m_array addObject:data.cash_on_delivery_amount];
    [m_array addObject:data.cash_on_delivery_real_amount];
    [m_array addObject:data.cash_on_delivery_causes_amount];
    [self.baseView updateDataSourceWithArray:m_array];
}

@end
