//
//  PublicBannerView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/8.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicBannerView.h"

@interface PublicBannerView () <UIScrollViewDelegate>



@end

@implementation PublicBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.baseView];
        [self.baseView addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.pageControl.autoresizingMask = UIViewAutoresizingNone;
        
        for (int i = 1; i < count_Banner_V; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * self.scrollView.height / count_Banner_V, self.scrollView.width, 1.0)];
            lineView.backgroundColor = separaterColor;
            [self.scrollView addSubview:lineView];
        }
    }
    return self;
}

#pragma setter
- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(kEdge, 0, self.width - kEdge * 2, self.height - 32)];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kEdge, kEdge, self.baseView.width - kEdge * 2, self.baseView.height - kEdge * 2)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl setCurrentPageIndicatorTintColor:navigationBarColor];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    }
    
    return _pageControl;
}

@end
