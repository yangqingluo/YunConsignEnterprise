//
//  ServiceCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/22.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "ServiceCell.h"

@implementation ServiceCell

- (void)setupFooter {
    [super setupFooter];
    [self.footerView updateDataSourceWithArray:@[@"地图", @"修改", @"删除"]];
}

#pragma mark - setter
- (void)setData:(AppServiceInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", data.open_city_name, data.service_name];
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.service_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"负责人：%@", data.responsible_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"门店电话：%@", data.service_phone];
    self.bodyLabel3.text = [NSString stringWithFormat:@"地址：%@", data.service_address];
}

@end
