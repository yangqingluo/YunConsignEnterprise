//
//  WaybillLogCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/23.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicRoundPointView.h"

@interface WaybillLogCell : UITableViewCell

@property (strong, nonatomic) PublicRoundPointView *roundPointView;
@property (strong, nonatomic) UIView *upLineView;
@property (strong, nonatomic) UIView *downLineView;
@property (strong, nonatomic) UIView *leftLineView;
@property (strong, nonatomic) UIView *rightLineView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *noteLabel;

@property (assign, nonatomic) BOOL isShowTopEdge;
@property (assign, nonatomic) BOOL isShowBottomEdge;

@property (copy, nonatomic) AppWaybillLogInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
