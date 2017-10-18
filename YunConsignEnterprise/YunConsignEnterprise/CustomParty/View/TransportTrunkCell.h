//
//  TransportTrunkCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface TransportTrunkCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *costCheckLabel;

@property (assign, nonatomic) NSInteger indextag;
@property (copy, nonatomic) AppTransportTrunkInfo *data;

@end
