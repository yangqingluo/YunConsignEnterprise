//
//  WaybillLoadCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLoadCell.h"

@implementation WaybillLoadCell

- (void)setupFooter {
    [super setupFooter];
    NSArray *m_array = @[@"配载", @"装车情况", @"打印清单", @"发车"];
    [self.footerView updateDataSourceWithArray:m_array];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setData:(AppCanLoadTransportTruckInfo *)data {
    _data = data;
    self.titleLabel.text = data.route;
    self.statusLabel.text = data.transport_truck_state_text;
    self.bodyLabel1.text = [NSString stringWithFormat:@"登记车辆：%@", data.truck_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"登记时间：%@", data.register_time];
    self.bodyLabel3.text = [NSString stringWithFormat:@"装车货量：%@",data.load_quantity];
}

@end
