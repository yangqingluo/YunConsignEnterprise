//
//  WaybillArrivalCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillArrivalCell.h"

@implementation WaybillArrivalCell

- (void)setupFooter {
    [super setupFooter];
    NSArray *m_array = @[@"运单明细", @"已到车"];
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppCanArrivalTransportTruckInfo *)data {
    _data = data;
    self.titleLabel.text = data.route;
    self.statusLabel.text = data.transport_truck_state_text;
    self.bodyLabel1.text = [NSString stringWithFormat:@"登记车辆：%@", data.truck_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"登记时间：%@", data.register_time];
    self.bodyLabel3.text = [NSString stringWithFormat:@"装车货量：%@",data.load_quantity];
    
}
@end
