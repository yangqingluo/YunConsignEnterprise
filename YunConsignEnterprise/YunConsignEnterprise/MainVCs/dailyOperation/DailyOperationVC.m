//
//  DailyOperationViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyOperationVC.h"

#import "PublicBannerView.h"

@interface DailyOperationVC ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) PublicBannerView *bannerView;

@end

@implementation DailyOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    CGFloat height_banner = screen_width + 32;
    _bannerView = [[PublicBannerView alloc] initWithFrame:CGRectMake(0, self.view.height - height_banner, screen_width, height_banner)];
    _bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_bannerView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, screen_width, self.bannerView.top + 0.7 * (self.bannerView.baseView.height / count_Banner_V) - self.navigationBarView.bottom)];
    _headerView.backgroundColor = navigationBarColor;
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:_headerView belowSubview:self.bannerView];
}

- (void)setupNav{
    [self createNavWithTitle:@"" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *i = [UIImage imageNamed:@"navbar_icon_menus"];
            [btn setImage:i forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(0, 0, 64, 44)];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [btn addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)editButtonAction {
    
}

#pragma getter


@end
