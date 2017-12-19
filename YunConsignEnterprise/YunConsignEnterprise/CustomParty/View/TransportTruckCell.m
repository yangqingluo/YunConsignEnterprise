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
    self.bodyLabel1.top = 0;
    self.bodyLabel1.height = self.bodyLabel2.top;
    
    _bodyLabelRight1 = NewLabel(self.bodyLabel1.frame, self.bodyLabel1.textColor, self.bodyLabel1.font, NSTextAlignmentLeft);
    _bodyLabelRight1.numberOfLines = 0;
    _bodyLabelRight1.lineBreakMode = NSLineBreakByCharWrapping;
    [self.bodyView addSubview:_bodyLabelRight1];
    
    self.bodyLabel1.text = @"登记车辆：";
    [AppPublic adjustLabelWidth:self.bodyLabel1];
    self.bodyLabelRight1.left = self.bodyLabel1.right;
    self.bodyLabelRight1.width = self.bodyView.width - kEdgeMiddle - self.bodyLabelRight1.left;
    
    _costCheckLabel = NewLabel(self.bodyLabel2.frame, nil, nil, NSTextAlignmentLeft);
    _costCheckLabel.top = self.bodyLabel3.bottom + kEdge;
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
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = dateStringWithTimeString(data.operate_time);
    
    self.bodyLabelRight1.text = [NSString stringWithFormat:@"%@", data.truck_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"登记运费：%@", data.cost_register];
    self.bodyLabel3.text = [NSString stringWithFormat:@"装车货量：%@", data.load_quantity];
    NSUInteger lines = 3;
    self.costCheckLabel.hidden = YES;
    if (self.indextag == 2 && data.cost_check.length) {
        lines++;
        [self showLabel:self.costCheckLabel conten:[NSString stringWithFormat:@"发放运费：%@", data.cost_check]];
    }
    [self refreshFooter];
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
