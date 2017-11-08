//
//  FreightCheckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/31.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightCheckCell.h"

@implementation FreightCheckCell



#pragma mark - setter
- (void)setData:(AppCheckFreightWayBillInfo *)data {
    _data = data;
    
    NSMutableArray *m_array = [NSMutableArray new];
    [m_array addObject:[NSString stringWithFormat:@"%d", (int)self.indexPath.row + 1]];
    [m_array addObject:data.goods_number];
    [m_array addObject:data.pay_now_amount];
    [m_array addObject:data.pay_on_delivery_amount];
    [m_array addObject:data.pay_on_receipt_amount];
    [self.baseView updateDataSourceWithArray:m_array];
}

@end