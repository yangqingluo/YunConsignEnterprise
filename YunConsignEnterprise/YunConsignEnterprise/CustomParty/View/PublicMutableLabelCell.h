//
//  PublicMutableLabelCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicMutableLabelView.h"

@interface PublicMutableLabelCell : UITableViewCell

@property (strong, nonatomic) PublicMutableLabelView *baseView;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSArray *valArray;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showWidth:(CGFloat)width showValueArray:(NSArray *)valArray;


+ (NSArray *)edgeSourceArray;
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
