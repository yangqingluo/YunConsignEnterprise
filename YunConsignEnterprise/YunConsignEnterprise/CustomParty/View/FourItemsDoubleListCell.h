//
//  FourItemsDoubleListCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourItemsDoubleListCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray<UILabel *> *labelArray;
@property (strong, nonatomic) UIView *baseView;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)addShowContents:(NSArray *)array;

@end
