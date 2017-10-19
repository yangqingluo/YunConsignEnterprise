//
//  TransportTruckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TransportTruckVC.h"
#import "TransportTruckTableVC.h"
#import "PublicQueryConditionVC.h"

#import "QCSlideSwitchView.h"

@interface TransportTruckVC ()<QCSlideSwitchViewDelegate>

@property (strong, nonatomic) QCSlideSwitchView *slidePageView;
@property (strong, nonatomic) NSMutableArray *viewArray;
@property (strong, nonatomic) AppQueryConditionInfo *condition;

@end

@implementation TransportTruckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self updateQueryCondition];
    [self.view addSubview:self.slidePageView];
    [self.slidePageView buildUI];
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewRightButton([UIImage imageNamed:@"navbar_icon_search"], nil);
            [btn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnAction {
    PublicQueryConditionVC *vc = [PublicQueryConditionVC new];
    vc.type = QueryConditionType_TransportTruck;
    vc.condition = [self.condition copy];
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object){
        if ([object isKindOfClass:[AppQueryConditionInfo class]]) {
            weakself.condition = (AppQueryConditionInfo *)object;
            [weakself updateQueryCondition];
        }
    };
    
    MainTabNavController *nav = [[MainTabNavController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:^{
        
    }];
}

- (void)updateQueryCondition {
    for (NSDictionary *m_dic in self.viewArray) {
        TransportTruckTableVC *vc = m_dic[@"VC"];
        if (vc) {
            vc.condition = [self.condition copy];
            vc.isResetCondition = YES;
            if ([self.viewArray indexOfObject:m_dic] == self.slidePageView.selectedIndex) {
                [vc becomeListed];
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

- (NSMutableArray *)viewArray{
    if (!_viewArray) {
        _viewArray = [NSMutableArray new];
        [_viewArray addObject:@{@"title":@"已登记",@"VC":[[TransportTruckTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:0]}];
        [_viewArray addObject:@{@"title":@"运输中",@"VC":[[TransportTruckTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:1]}];
        [_viewArray addObject:@{@"title":@"已完成",@"VC":[[TransportTruckTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:2]}];
    }
    
    return _viewArray;
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
