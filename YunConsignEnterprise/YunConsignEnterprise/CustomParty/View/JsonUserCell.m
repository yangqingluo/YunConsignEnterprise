//
//  JsonUserCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/28.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "JsonUserCell.h"

@implementation JsonUserCell

- (void)setupFooter {
    [super setupFooter];
    [self.footerView updateDataSourceWithArray:@[@"删除", @"详情"]];
}

#pragma mark - setter
- (void)setData:(AppUserInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", data.user_name];
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.user_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"网点：%@", data.service_name];
    self.bodyLabel2.text = [NSString stringWithFormat:@"角色：%@", data.role_name];
    
    NSUInteger lines = 2;
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
