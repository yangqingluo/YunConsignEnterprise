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

@property (strong, nonatomic) NSMutableArray *showViews;
@property (assign, nonatomic) PublicMutableLabelAlignment labelAlignment;
@property (assign, nonatomic) BOOL showVerticalSeparator;

- (void)updateDataSourceWithArray:(NSArray *)array;
- (void)updateEdgeSourceWithArray:(NSArray *)array;

@end
