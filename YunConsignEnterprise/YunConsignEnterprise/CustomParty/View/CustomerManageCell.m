//
//  CustomerManageCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CustomerManageCell.h"

@implementation CustomerManageCell

- (void)setupFooter {
    [super setupFooter];
    NSArray *m_array = @[@"编辑", @"删除"];
    [self.footerView updateDataSourceWithArray:m_array];
}

- (void)setupBody {
    [super setupBody];
    _quantityLabel = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel1.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel1.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_quantityLabel];
}

#pragma mark - setter
- (void)setData:(AppCustomerInfo *)data {
    _data = data;
    self.titleLabel.text = data.freight_cust_name;
    self.statusLabel.text = data.belong_city_name;
    self.bodyLabel1.text = [NSString stringWithFormat:@"电话：%@", data.phone];
    self.bodyLabel2.text = [NSString stringWithFormat:@"发货：%@", data.last_deliver_goods];
    
    NSUInteger lines = 2;
    if (data.note.length) {
        self.bodyLabel3.text = [NSString stringWithFormat:@"备注：%@",data.note];
    }
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
