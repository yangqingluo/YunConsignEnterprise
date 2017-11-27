//
//  PublicResultWithScrollTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/26.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicResultWithScrollTableVC.h"

@interface PublicResultWithScrollTableVC ()

@end

@implementation PublicResultWithScrollTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.scrollView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (UIScrollView *)scrollView {
    if (_scrollView == nil){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight |  UIViewAutoresizingFlexibleWidth;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    
    return _scrollView;
}

@end
