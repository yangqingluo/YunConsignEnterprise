//
//  PublicTTLoadFooterView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicTTLoadFooterView.h"

@interface PublicTTLoadFooterView ()

@property (strong, nonatomic) UIView *baseView;

@end

@implementation PublicTTLoadFooterView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT + 0.6 * DEFAULT_BAR_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _summaryView = [[PublicFooterSummaryView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.6 * DEFAULT_BAR_HEIGHT)];
        _summaryView.backgroundColor = [UIColor whiteColor];
        _summaryView.textLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
        _summaryView.subTextLabel.font = _summaryView.textLabel.font;
        [self addSubview:_summaryView];
        
        _actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 0.25 * self.width, self.summaryView.bottom, 0.25 * self.width, self.height - self.summaryView.bottom)];
        _actionBtn.backgroundColor = EmphasizedColor;
        _actionBtn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [_actionBtn setTitleColor:baseTextColor forState:UIControlStateNormal];
        [self addSubview:_actionBtn];
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.summaryView.bottom, _actionBtn.left - appSeparaterLineSize, self.height - self.summaryView.bottom)];
        _baseView.backgroundColor = MainColor;
        [self addSubview:_baseView];
        
        _selectBtn = [[UDImageLabelButton alloc] initWithFrame:CGRectMake(0, 0, self.baseView.width, _baseView.height)];
        _selectBtn.upImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_checkbox_w_normal"] highlightedImage:[UIImage imageNamed:@"list_icon_checkbox_w_selected"]];
        _selectBtn.upImageView.left = kEdgeMiddle;
        _selectBtn.upImageView.centerY = 0.5 * _selectBtn.height;
        _selectBtn.downLabel = NewLabel(CGRectMake(_selectBtn.upImageView.right + kEdge, 0, _selectBtn.width - (_selectBtn.upImageView.right + kEdge), _selectBtn.height), [UIColor whiteColor], [AppPublic appFontOfSize:appButtonTitleFontSize], NSTextAlignmentLeft);
        _selectBtn.downLabel.text = @"全选";
        [_selectBtn addSubview:_selectBtn.upImageView];
        [_selectBtn addSubview:_selectBtn.downLabel];
        [self.baseView addSubview:_selectBtn];
    }
    return self;
}

@end
