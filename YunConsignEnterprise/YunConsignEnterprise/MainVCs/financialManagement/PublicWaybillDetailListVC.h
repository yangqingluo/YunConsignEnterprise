//
//  PublicWaybillDetailListVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicResultTableVC.h"

@interface PublicWaybillDetailListVC : PublicResultTableVC

@property (copy, nonatomic) AppCodLoanApplyInfo *codApplyData;
@property (assign, nonatomic) BOOL isChecker;//只有在审核者视角才显示驳回

@end
