//
//  WaybillLogTableVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/23.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaybillLogTableVC : UITableViewController

@property (strong, nonatomic) AppWayBillDetailInfo *detailData;

- (instancetype)initWithStyle:(UITableViewStyle)style andIndexTag:(NSInteger)index;
- (void)becomeListed;
- (void)becomeUnListed;

@end
