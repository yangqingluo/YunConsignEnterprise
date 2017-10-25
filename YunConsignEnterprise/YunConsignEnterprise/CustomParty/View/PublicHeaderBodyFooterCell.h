//
//  PublicHeaderContentFooterCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicMutableButtonView.h"
#import "PublicHeaderBodyCell.h"

@interface PublicHeaderBodyFooterCell : PublicHeaderBodyCell

@property (strong, nonatomic) PublicMutableButtonView *footerView;

- (void)setupFooter;

@end
