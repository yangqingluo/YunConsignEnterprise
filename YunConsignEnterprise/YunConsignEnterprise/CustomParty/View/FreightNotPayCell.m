//
//  FreightNotPayCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightNotPayCell.h"

@implementation FreightNotPayCell

#pragma mark - setter
- (void)setData:(AppWayBillDetailInfo *)data {
    _data = data;
    
    NSMutableArray *m_array = [NSMutableArray new];
    [m_array addObject:[NSString stringWithFormat:@"%d", (int)self.indexPath.row + 1]];
    [m_array addObject:notNilString(data.goods_number, nil)];
    [m_array addObject:notNilString(data.consignee_name, nil)];
    for (NSString *val in self.valArray) {
        [m_array addObject:notNilString([data valueForKey:val], @"0")];
    }
    [self.baseView updateDataSourceWithArray:m_array];
}

@end
