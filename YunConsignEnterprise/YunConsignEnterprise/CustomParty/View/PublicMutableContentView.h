//
//  PublicMutableContentView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PublicMutableContentAlignmentLeft = 0,
    PublicMutableContentAlignmentRight
} PublicMutableContentAlignment;

@interface PublicMutableContentView : UIView

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *edgeSource;
@property (strong, nonatomic) NSMutableArray *showViews;
@property (assign, nonatomic) BOOL showVerticalSeparator;
@property (assign, nonatomic) BOOL showTopHorizontalSeparator;
@property (assign, nonatomic) BOOL showBottomHorizontalSeparator;
@property (assign, nonatomic) PublicMutableContentAlignment mutableContentAlignment;
@property (assign, nonatomic) CGFloat defaultWidthScale;

- (void)updateDataSourceWithArray:(NSArray *)array;
- (void)updateEdgeSourceWithArray:(NSArray *)array;
- (void)refreshContent;
- (void)refreshHorizontalSeparators;

@end
