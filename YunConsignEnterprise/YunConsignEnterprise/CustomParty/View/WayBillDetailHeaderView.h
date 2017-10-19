//
//  WayBillDetailHeaderView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WayBillDetailHeaderView : UIView

@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIImageView *urgentImageView;

@property (strong, nonatomic) UILabel *senderDetailLabel;
@property (strong, nonatomic) UILabel *receiverDetailLabel;

@property (copy, nonatomic) AppWayBillDetailInfo *data;

@end
