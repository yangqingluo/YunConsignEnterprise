//
//  PublicTabViewController.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicViewController.h"
#import "PublicBannerView.h"
#import "PublicUserHeaderView.h"

@interface PublicTabViewController : AppBasicViewController

@property (strong, nonatomic) PublicUserHeaderView *headerView;
@property (strong, nonatomic) PublicBannerView *bannerView;

@end
