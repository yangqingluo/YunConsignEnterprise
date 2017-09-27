//
//  TransportTrunkCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportTrunkCell : UITableViewCell

@property (strong, nonatomic) UIView *baseView;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UILabel *truckLabel;
@property (strong, nonatomic) UILabel *costRegisterLabel;
@property (strong, nonatomic) UILabel *costCheckLabel;
@property (strong, nonatomic) UILabel *loadQuantityLabel;

@property (strong, nonatomic) UIView *footerView;

@property (assign, nonatomic) NSInteger indextag;
@property (copy, nonatomic) AppTransportTrunkInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
