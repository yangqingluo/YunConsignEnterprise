//
//  WaybillEditHeaderView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaybillTitleView.h"

@interface WaybillEditHeaderView : UIView

@property (strong, nonatomic) WaybillTitleView *titleView;
@property (strong, nonatomic) UILabel *senderLabel;
@property (strong, nonatomic) UILabel *receiverLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UIButton *senderButton;
@property (strong, nonatomic) UIButton *receiverButton;

@property (strong, nonatomic) UILabel *senderDetailLabel;
@property (strong, nonatomic) UILabel *receiverDetailLabel;

@property (weak, nonatomic) AppWayBillDetailInfo *detailData;

@end
