//
//  PublicInputHeaderView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicInputHeaderView.h"

@implementation PublicInputHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _baseView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, self.height)];
        [self addSubview:_baseView];
        
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kEdge, 50, self.baseView.height - 2 * kEdge)];
        [_searchBtn setTitle:@"查询" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _searchBtn.backgroundColor = AuxiliaryColor;
        _searchBtn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [self.baseView addRightView:_searchBtn];
        [AppPublic roundCornerRadius:_searchBtn cornerRadius:kButtonCornerRadius];
        
        [self addSubview:NewSeparatorLine(CGRectMake(0, 0, self.width, appSeparaterLineSize))];
        [self addSubview:NewSeparatorLine(CGRectMake(0, self.height - appSeparaterLineSize, self.width, appSeparaterLineSize))];
    }
    return self;
}

@end
