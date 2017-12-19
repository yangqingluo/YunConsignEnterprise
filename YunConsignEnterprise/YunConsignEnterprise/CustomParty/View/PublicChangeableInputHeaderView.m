//
//  PublicChangeableInputHeaderView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicChangeableInputHeaderView.h"

@implementation PublicChangeableInputHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.baseView.textLabel.height = 0.8 * self.baseView.height;
        self.baseView.textLabel.centerY = 0.5 * self.baseView.height;
        self.baseView.textLabel.backgroundColor = CellHeaderLightBlueColor;
        [AppPublic roundCornerRadius:self.baseView.textLabel cornerRadius:kViewCornerRadius];
    }
    return self;
}

#pragma mark - setter
- (void)setChangeableData:(AppDataDictionary *)changeableData {
    _changeableData = changeableData;
    self.baseView.textLabel.text = notNilString(_changeableData.item_name, @"请选择");
    
}

@end
