//
//  PublicMutableLabelListView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PublicMutableLabelAlignmentLeft = 0,
    PublicMutableLabelAlignmentRight
} PublicMutableLabelAlignment;

@interface PublicMutableLabelView : UIView

@property (assign, nonatomic) PublicMutableLabelAlignment labelAlignment;

- (void)updateDataSourceWithArray:(NSArray *)array;

@end
