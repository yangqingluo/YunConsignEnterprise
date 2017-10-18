//
//  WaybillArrivalCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillArrivalCell.h"

@implementation WaybillArrivalCell

- (void)setupBody {
    [super setupBody];
    _arriveTimeLabel = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel2.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel2.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_arriveTimeLabel];
    
    _noHandoverLabel = NewLabel(self.arriveTimeLabel.frame, nil, nil, NSTextAlignmentLeft);
    _noHandoverLabel.top = self.bodyLabel3.top;
    [self.bodyView addSubview:_noHandoverLabel];
}

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
    self.bodyLabel1.text = [NSString stringWithFormat:@"车辆：%@", data.truck_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"登记：%@", data.register_time];
    self.bodyLabel3.text = [NSString stringWithFormat:@"货量：%@",data.load_quantity];
    
    self.arriveTimeLabel.text = [NSString stringWithFormat:@"到车：%@", data.arrival_time];
    NSDictionary *dic1 = @{NSFontAttributeName:[AppPublic appFontOfSize:appLabelFontSize], NSForegroundColorAttributeName:baseTextColor};
    NSDictionary *dic2 = @{NSFontAttributeName:[AppPublic appFontOfSize:appLabelFontSize], NSForegroundColorAttributeName:MainColor};
    
    NSMutableAttributedString *m_string = [NSMutableAttributedString new];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"未交接：" attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", data.nohandover_count] attributes:dic2]];
    self.noHandoverLabel.attributedText = m_string;
}

@end
