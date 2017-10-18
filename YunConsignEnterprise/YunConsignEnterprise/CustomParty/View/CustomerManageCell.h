//
//  CustomerManageCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface CustomerManageCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *quantityLabel;

@property (copy, nonatomic) AppCustomerInfo *data;

@end
