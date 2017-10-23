//
//  WaybillLogVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/23.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLogVC.h"
#import "WaybillLogTableVC.h"

#import "QCSlideSwitchView.h"

@interface WaybillLogVC ()<QCSlideSwitchViewDelegate>

@property (strong, nonatomic) QCSlideSwitchView *slidePageView;
@property (strong, nonatomic) NSMutableArray *viewArray;

@end

@implementation WaybillLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.slidePageView];
    [self.slidePageView buildUI];
}

- (void)setupNav {
    [self createNavWithTitle:@"物流跟踪" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
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
        [_viewArray addObject:@{@"title":@"物流详情",@"VC":[[WaybillLogTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:0]}];
        [_viewArray addObject:@{@"title":@"代收款",@"VC":[[WaybillLogTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:1]}];
        [_viewArray addObject:@{@"title":@"回单",@"VC":[[WaybillLogTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:2]}];
        [_viewArray addObject:@{@"title":@"签收单",@"VC":[[WaybillLogTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:2]}];
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
