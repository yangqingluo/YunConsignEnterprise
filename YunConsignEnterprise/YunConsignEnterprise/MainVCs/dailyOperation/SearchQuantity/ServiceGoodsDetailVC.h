//
//  ServiceGoodsDetailVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicResultTableVC.h"

@interface ServiceGoodsDetailVC : PublicResultTableVC

@property (copy, nonatomic) AppServiceGoodsQuantityInfo *serviceQuantityData;
@property (strong, nonatomic) NSString *searchType;

@end
