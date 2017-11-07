//
//  PublicFMWaybillQueryCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyCell.h"

@interface PublicFMWaybillQueryCell : PublicHeaderBodyCell

@property (copy, nonatomic) AppWayBillDetailInfo *data;

@property (strong, nonatomic) UILabel *bodyLabelRight1;

@end
