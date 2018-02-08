//
//  GrossMarginCountCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/2/8.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "GrossMarginCountCell.h"

@implementation GrossMarginCountCell

#pragma mark - setter
- (void)setData:(AppDailyGrossMarginInfo *)data {
    _data = data;
    
    NSMutableArray *m_array = [NSMutableArray new];
    [m_array addObject:[NSString stringWithFormat:@"%d", (int)self.indexPath.row + 1]];
    for (NSString *val in self.valArray) {
        [m_array addObject:notNilString([data valueForKey:val], @"0")];
    }
    [self.baseView updateDataSourceWithArray:m_array];
}

@end
