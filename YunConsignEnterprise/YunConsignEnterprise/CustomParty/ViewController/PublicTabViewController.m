//
//  PublicTabViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicTabViewController.h"

@interface PublicTabViewController ()

@end

@implementation PublicTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat height_banner = screen_width + 32;
    if (screen_height - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT - height_banner <  148) {
        height_banner += (screen_height - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT - height_banner -  148);
    }
    _bannerView = [[PublicBannerView alloc] initWithFrame:CGRectMake(0, self.view.height - height_banner, screen_width, height_banner)];
    _bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_bannerView];
    
    _headerView = [[PublicUserHeaderView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, screen_width, self.bannerView.top + 0.7 * (self.bannerView.baseView.height / count_Banner_V) - self.navigationBarView.bottom)];
    _headerView.backgroundColor = MainColor;
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:_headerView belowSubview:self.bannerView];
    
    self.headerView.userData = [UserPublic getInstance].userData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter


@end
