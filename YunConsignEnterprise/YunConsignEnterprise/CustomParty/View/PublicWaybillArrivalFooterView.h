//
//  PublicWaybillArrivalFooterView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDImageLabelButton.h"

@interface PublicWaybillArrivalFooterView : UIView

@property (strong, nonatomic) UIView *summaryView;
@property (strong, nonatomic) UDImageLabelButton *selectBtn;//全选按钮
@property (strong, nonatomic) UDImageLabelButton *ignoreBtn;//忽略按钮
@property (strong, nonatomic) UIButton *arriveBtn;//交接按钮
@property (strong, nonatomic) UIButton *printBtn1;//打印按钮1
@property (strong, nonatomic) UIButton *printBtn2;//打印按钮2

@end
