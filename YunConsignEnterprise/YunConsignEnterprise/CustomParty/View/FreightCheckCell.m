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
    [m_array addObject:notNilString(data.goods_number, nil)];
    [m_array addObject:notNilString(data.pay_now_amount, nil)];
    [m_array addObject:notNilString(data.pay_on_delivery_amount, nil)];
    [m_array addObject:notNilString(data.pay_on_receipt_amount, nil)];
    [self.baseView updateDataSourceWithArray:m_array];
}

@end
