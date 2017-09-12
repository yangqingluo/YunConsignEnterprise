//
//  PublicBannerView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/8.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Event_BannerButtonClicked @"Event_BannerButtonClicked"
#define count_Banner_H  3
#define count_Banner_V  3

@interface PublicBannerView : UIView

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *dataSource;

@end
