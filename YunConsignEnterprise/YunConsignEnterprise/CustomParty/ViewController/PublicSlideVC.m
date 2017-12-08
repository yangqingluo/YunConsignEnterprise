//
//  PublicSlideVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/2.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicSlideVC.h"
#import "PublicResultTableVC.h"

@interface PublicSlideVC ()



@end

@implementation PublicSlideVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (NSDictionary *m_dic in self.viewArray) {
        PublicResultTableVC *vc = m_dic[@"VC"];
        if (vc) {
            if (self.slidePageView.superview) {
                if ([self.viewArray indexOfObject:m_dic] == self.slidePageView.selectedIndex) {
                    [vc viewWillAppear:animated];
                }
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self updateQueryCondition];
    [self.view addSubview:self.slidePageView];
    [self.slidePageView buildUI];
}

- (void)setupNav {
    
}

- (void)updateQueryCondition {
    for (NSDictionary *m_dic in self.viewArray) {
        PublicResultTableVC *vc = m_dic[@"VC"];
        if (vc) {
            vc.condition = [self.condition copy];
            vc.isResetCondition = YES;
            if (self.slidePageView.superview) {
                if ([self.viewArray indexOfObject:m_dic] == self.slidePageView.selectedIndex) {
                    [vc becomeListed];
                }
            }
        }
    }
}

#pragma mark - getter
- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
    }
    return _condition;
}

- (QCSlideSwitchView *)slidePageView{
    if (!_slidePageView) {
        _slidePageView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, self.view.width, self.view.height - self.navigationBarView.bottom)];
        _slidePageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        _slidePageView.delegate = self;
        _slidePageView.topScrollView.backgroundColor = [UIColor whiteColor];
        _slidePageView.tabItemNormalColor = baseTextColor;
        _slidePageView.tabItemSelectedColor = MainColor;
        _slidePageView.shadowImageView.backgroundColor = baseSeparatorColor;
    }
    
    return _slidePageView;
}

#pragma mark - QCSlider
- (CGFloat)widthOfTab:(NSUInteger)index{
    return self.view.bounds.size.width / self.viewArray.count;
}
- (NSString *)titleOfTab:(NSUInteger)index{
    NSDictionary *dic = self.viewArray[index];
    return dic[@"title"];
}

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view{
    return self.viewArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    NSDictionary *dic = self.viewArray[number];
    return dic[@"VC"];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number{
    NSDictionary *dic = self.viewArray[number];
    UIViewController *listVC = dic[@"VC"];
    if ([listVC respondsToSelector:@selector(becomeListed)]) {
        [listVC performSelector:@selector(becomeListed)];
    }
    
    [self.slidePageView showRedPoint:NO withIndex:number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didunselectTab:(NSUInteger)number{
    NSDictionary *dic = self.viewArray[number];
    UIViewController *listVC = dic[@"VC"];
    if ([listVC respondsToSelector:@selector(becomeUnListed)]) {
        [listVC performSelector:@selector(becomeUnListed)];
    }
}

@end
