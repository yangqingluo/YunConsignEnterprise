//
//  PublicResultWithScrollTableVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/26.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicResultTableVC.h"

@interface PublicResultWithScrollTableVC : PublicResultTableVC<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end
