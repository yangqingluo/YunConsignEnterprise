//
//  AddGoodsListHeaderView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicListHeaderView.h"

#define Event_AddGoodsListHeaderViewButtonClicked @"Event_AddGoodsListHeaderViewButtonClicked"

@interface AddGoodsListHeaderView : PublicListHeaderView

@property (strong, nonatomic) AppGoodsInfo *data;

@end
