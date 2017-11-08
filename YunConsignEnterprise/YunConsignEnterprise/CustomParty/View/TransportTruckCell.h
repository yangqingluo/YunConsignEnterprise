//
//  TransportTruckCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface TransportTruckCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *bodyLabelRight1;
@property (strong, nonatomic) UILabel *costCheckLabel;

@property (assign, nonatomic) NSInteger indextag;
@property (copy, nonatomic) AppTransportTruckInfo *data;

@end
