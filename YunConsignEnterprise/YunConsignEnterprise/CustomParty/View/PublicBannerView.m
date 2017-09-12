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
#import "UIResponder+Router.h"

@interface PublicBannerView () <UIScrollViewDelegate>



@end

@implementation PublicBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.baseView];
        [self.baseView addSubview:self.scrollView];
        
        self.pageControl.center = CGPointMake(0.5 * self.width, self.height - 16);
        [self addSubview:self.pageControl];
        self.pageControl.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)buttonAction:(UIButton *)button {
    [self routerEventWithName:Event_BannerButtonClicked userInfo:[NSIndexPath indexPathForRow:button.tag inSection:self.tag]];
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
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl setCurrentPageIndicatorTintColor:MainColor];
        [_pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    }
    return _pageControl;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int currentPage = (x + scrollViewW / 2) / scrollViewW;
    _pageControl.currentPage = currentPage;
}

#pragma mark - setter
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    NSUInteger pages = dataSource.count > 0 ? (dataSource.count - 1) / (count_Banner_H * count_Banner_V) + 1 : 0;
    self.scrollView.contentSize = CGSizeMake(pages * self.scrollView.width, self.scrollView.height);
    self.pageControl.numberOfPages = pages;
    [self addSeparatorLines];
    CGFloat btnWidth = self.scrollView.width / count_Banner_H;
    CGFloat btnHeight = self.scrollView.height / count_Banner_V;
    for (NSUInteger i = 0; i < dataSource.count; i++) {
        AppAccessInfo *item = _dataSource[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
        button.center = CGPointMake((i / (count_Banner_H * count_Banner_V) * self.scrollView.width) + ((i % count_Banner_H) + 0.5) * btnWidth, ((i % (count_Banner_H * count_Banner_V) / count_Banner_H) + 0.5) * btnHeight);
        [button setImage:[UIImage imageNamed:@"tabbar_icon_daily_normal"] forState:UIControlStateNormal];
        if (item.menu_icon.length) {
            [button sd_setImageWithURL:[NSURL URLWithString:item.menu_icon] forState:UIControlStateNormal];
        }
        [button setTitle:item.menu_name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:baseSeparatorColor] forState:UIControlStateHighlighted];
        [button verticalImageAndTitle:kEdge];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.scrollView addSubview:button];
    }
}

- (void)addSeparatorLines {
    for (NSUInteger currentPage = 0; currentPage < self.pageControl.numberOfPages; currentPage++) {
        CGFloat x = currentPage * self.scrollView.width;
        for (int i = 1; i < count_Banner_V; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 0, i * self.scrollView.height / count_Banner_V, self.scrollView.width, 1.0)];
            lineView.backgroundColor = baseSeparatorColor;
            [self.scrollView addSubview:lineView];
        }
        for (int i = 1; i < count_Banner_H; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x + i * self.scrollView.width / count_Banner_H, 0, 1.0, self.scrollView.height)];
            lineView.backgroundColor = baseSeparatorColor;
            [self.scrollView addSubview:lineView];
        }
    }
}

@end
