//
//  WaybillChangeCheckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/1/11.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "WaybillChangeCheckCell.h"

@implementation WaybillChangeCheckCell

- (void)refreshFooter {
    NSArray *m_array = @[@"运单详情"];
    if ([self.data.change_state integerValue] == WAYBILL_CHANGE_APPLY_STATE_1) {
        m_array = @[@"审核通过", @"驳回", @"运单详情"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

@end
