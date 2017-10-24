//
//  TransportTruckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TransportTruckCell.h"

@implementation TransportTruckCell

- (void)setupFooter {
    [super setupFooter];
    [self refreshFooter];
}

- (void)refreshFooter {
    NSArray *m_array = @[@"装车详情", @"取消派车", @"发车"];
    if (self.indextag == 1) {
        m_array = @[@"装车详情"];
    }
    else if (self.indextag == 2) {
        if (self.data.cost_check.length) {
            m_array = @[@"装车详情"];
        }
        else {
            m_array = @[@"装车详情", @"发放运费"];
        }
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

- (void)setupBody {
    [super setupBody];
    _costCheckLabel = NewLabel(self.bodyLabel2.frame, nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_costCheckLabel];
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
- (void)setData:(AppTransportTruckInfo *)data {
    _data = data;
    self.titleLabel.text = data.route;
    self.statusLabel.text = dateStringWithTimeString(data.operate_time);
    [AppPublic adjustLabelWidth:self.statusLabel];
    self.statusLabel.right = self.headerView.right - kEdgeMiddle;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"登记车辆：%@", data.truck_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"登记运费：%@", data.cost_register];
    [AppPublic adjustLabelWidth:self.bodyLabel2];
    if (data.cost_check.length) {
        self.costCheckLabel.hidden = NO;
        self.costCheckLabel.text = [NSString stringWithFormat:@"发放运费：%@", data.cost_check];
        [AppPublic adjustLabelWidth:self.costCheckLabel];
        self.costCheckLabel.left = self.bodyLabel2.right + kEdgeBig;
    }
    else {
        self.costCheckLabel.hidden = YES;
    }
    
    self.bodyLabel3.text = [NSString stringWithFormat:@"装车货量：%@", data.load_quantity];
    [self refreshFooter];
}

@end
