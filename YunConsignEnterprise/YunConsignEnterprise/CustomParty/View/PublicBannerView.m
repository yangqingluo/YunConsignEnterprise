//
//  PublicBannerView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/8.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicBannerView.h"
#import "UIButton+ImageAndText.h"
#import "UIButton+WebCache.h"

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
    }
    return self;
}

- (void)buttonAction:(UIButton *)button {
    
}

#pragma mark - getter
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

#pragma mark - setter
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 1; i < count_Banner_V; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * self.scrollView.height / count_Banner_V, self.scrollView.width, 1.0)];
        lineView.backgroundColor = separaterColor;
        [self.scrollView addSubview:lineView];
    }
    
    CGFloat btnWidth = self.scrollView.width / count_Banner_H;
    CGFloat btnHeight = self.scrollView.height / count_Banner_V;
    for (NSUInteger i = 0; i < dataSource.count; i++) {
        AppAccessInfo *item = _dataSource[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
        button.center = CGPointMake((i / (count_Banner_H * count_Banner_V) * self.scrollView.width) + ((i % count_Banner_H) + 0.5) * btnWidth, ((i % (count_Banner_H * count_Banner_V) / count_Banner_H) + 0.5) * btnHeight);
        [button sd_setImageWithURL:[NSURL URLWithString:item.menu_icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tabbar_icon_daily_normal"]];
        [button setTitle:item.menu_name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:separaterColor] forState:UIControlStateHighlighted];
        [button verticalImageAndTitle:kEdge];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.scrollView addSubview:button];
    }
}

@end
