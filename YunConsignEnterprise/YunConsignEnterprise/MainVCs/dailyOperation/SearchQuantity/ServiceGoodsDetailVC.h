//
//  ServiceGoodsDetailVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicTableViewController.h"

@interface ServiceGoodsDetailVC : AppBasicTableViewController

@property (copy, nonatomic) AppQueryConditionInfo *condition;
@property (copy, nonatomic) AppServiceGoodsQuantityInfo *serviceQuantityData;

@end
