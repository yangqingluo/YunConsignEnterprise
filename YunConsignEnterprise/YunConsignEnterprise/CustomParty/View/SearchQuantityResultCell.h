//
//  SearchQuantityResultCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchQuantityResultCell : UITableViewCell

@property (strong, nonatomic) UILabel *firstLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UILabel *thirdLabel;
//@property (strong, nonatomic) UIButton *actionBtn;

@property (copy, nonatomic) AppGoodsQuantityInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
