//
//  WayBillSRHeaderView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//  Sender Receiver Header View
//

#import <UIKit/UIKit.h>

@interface WayBillSRHeaderView : UIView

@property (strong, nonatomic) UILabel *senderLabel;
@property (strong, nonatomic) UILabel *receiverLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UIButton *senderButton;
@property (strong, nonatomic) UIButton *receiverButton;

@property (strong, nonatomic) UILabel *senderDetailLabel;
@property (strong, nonatomic) UILabel *receiverDetailLabel;

@property (strong, nonatomic) AppSendReceiveInfo *senderInfo;
@property (strong, nonatomic) AppSendReceiveInfo *receiverInfo;
@property (strong, nonatomic) NSDate *date;

@end
