//
//  PublicWaybillArrivalFooterView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicWaybillArrivalFooterView.h"

@interface PublicWaybillArrivalFooterView ()

@property (strong, nonatomic) UIView *baseView;

@end

@implementation PublicWaybillArrivalFooterView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT + 0.6 * DEFAULT_BAR_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _summaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.6 * DEFAULT_BAR_HEIGHT)];
        _summaryView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_summaryView];
        
        _ignoreBtn = [[UDImageLabelButton alloc] initWithFrame:CGRectMake(0, 0, _summaryView.width, _summaryView.height)];
        _ignoreBtn.upImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_checkbox_normal"] highlightedImage:[UIImage imageNamed:@"list_icon_checkbox_selcted"]];
        _ignoreBtn.upImageView.left = kEdgeMiddle;
        _ignoreBtn.upImageView.centerY = 0.5 * _ignoreBtn.height;
        _ignoreBtn.downLabel = NewLabel(CGRectMake(_ignoreBtn.upImageView.right + kEdge, 0, _ignoreBtn.width - (_ignoreBtn.upImageView.right + kEdge), _ignoreBtn.height), baseTextColor, [AppPublic appFontOfSize:appButtonTitleFontSizeSmall], NSTextAlignmentLeft);
        _ignoreBtn.downLabel.text = @"忽略已打印";
        [_ignoreBtn addSubview:_ignoreBtn.upImageView];
        [_ignoreBtn addSubview:_ignoreBtn.downLabel];
        [self.summaryView addSubview:_ignoreBtn];
        
        _subTextLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, self.summaryView.width - 2 * kEdgeMiddle, self.summaryView.height), secondaryTextColor, nil, NSTextAlignmentRight);
        [self.summaryView addSubview:_subTextLabel];
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.summaryView.bottom, self.width, self.height - self.summaryView.bottom)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_baseView];
        
        CGFloat width_btn = 0.25 * self.width;
        _selectBtn = [[UDImageLabelButton alloc] initWithFrame:CGRectMake(0, 0, width_btn - appSeparaterLineSize, _baseView.height)];
        _selectBtn.backgroundColor = MainColor;
        _selectBtn.upImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_checkbox_w_normal"] highlightedImage:[UIImage imageNamed:@"list_icon_checkbox_w_selected"]];
        _selectBtn.upImageView.left = kEdgeMiddle;
        _selectBtn.upImageView.centerY = 0.5 * _selectBtn.height;
        _selectBtn.downLabel = NewLabel(CGRectMake(_selectBtn.upImageView.right + kEdge, 0, _selectBtn.width - (_selectBtn.upImageView.right + kEdge), _selectBtn.height), [UIColor whiteColor], [AppPublic appFontOfSize:appButtonTitleFontSize], NSTextAlignmentLeft);
        _selectBtn.downLabel.text = @"全选";
        [_selectBtn addSubview:_selectBtn.upImageView];
        [_selectBtn addSubview:_selectBtn.downLabel];
        [self.baseView addSubview:_selectBtn];
        
        _arriveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self adjustButton:_arriveBtn];
        _arriveBtn.left = width_btn;
        [_arriveBtn setTitle:@"到货交接" forState:UIControlStateNormal];
        [self.baseView addSubview:_arriveBtn];
        
        _printBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self adjustButton:_printBtn1];
        _printBtn1.left = 2 * width_btn;
        [_printBtn1 setTitle:@"打印大票" forState:UIControlStateNormal];
        [self.baseView addSubview:_printBtn1];
        
        _printBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self adjustButton:_printBtn2];
        _printBtn2.left = 3 * width_btn;
        [_printBtn2 setTitle:@"打签收单" forState:UIControlStateNormal];
        [self.baseView addSubview:_printBtn2];
    }
    return self;
}

- (void)adjustButton:(UIButton *)button {
    button.frame = CGRectMake(0, 0, 0.25 * self.width - appSeparaterLineSize, self.baseView.height);
    button.backgroundColor = MainColor;
    button.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
