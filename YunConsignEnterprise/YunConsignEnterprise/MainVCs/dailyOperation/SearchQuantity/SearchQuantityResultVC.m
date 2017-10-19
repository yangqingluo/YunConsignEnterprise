//
//  SearchQuantityResultVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SearchQuantityResultVC.h"
#import "SearchQuantityResultTableVC.h"

#import "QCSlideSwitchView.h"

@interface SearchQuantityResultVC ()<QCSlideSwitchViewDelegate>

@property (strong, nonatomic) QCSlideSwitchView *slidePageView;
@property (strong, nonatomic) NSMutableArray *viewArray;

@end

@implementation SearchQuantityResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.slidePageView];
    [self.slidePageView buildUI];
}

- (void)setupNav {
    [self createNavWithTitle:@"货量情况" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            
        }
        return nil;
    }];
}

- (void)goBack {
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
        SearchQuantityResultTableVC *vc0 = [[SearchQuantityResultTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:0];
        vc0.condition = [self.condition copy];
        [_viewArray addObject:@{@"title":@"线路货量",@"VC":vc0}];
        
        SearchQuantityResultTableVC *vc1 = [[SearchQuantityResultTableVC alloc] initWithStyle:UITableViewStyleGrouped andIndexTag:1];
        vc1.condition = [self.condition copy];
        [_viewArray addObject:@{@"title":@"门店货量",@"VC":vc1}];
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
