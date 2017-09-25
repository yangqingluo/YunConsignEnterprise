//
//  DoubleInputCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicInputCellView.h"

@interface DoubleInputCell : UITableViewCell

@property (strong, nonatomic) PublicInputCellView *baseView;
@property (strong, nonatomic) PublicInputCellView *anotherBaseView;
@property (assign, nonatomic) BOOL isShowBottomEdge;

@end
