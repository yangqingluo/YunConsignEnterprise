//
//  PublicResultWithScrollTableVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/26.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicResultTableVC.h"

typedef NS_ENUM(NSInteger, PublicResultWithScrollTableType) {
    PublicResultWithScrollTableType_DEFAULT = 0,
    PublicResultWithScrollTableType_FreightCheck,//运输款对账
    PublicResultWithScrollTableType_FreightNotPay,//未收运输款
};

@interface PublicResultWithScrollTableVC : PublicResultTableVC<UIScrollViewDelegate>

@property (assign, nonatomic) PublicResultWithScrollTableType type;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *valArray;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) NSMutableArray *edgeArray;

@end
