//
//  PublicMutableLabelListView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicMutableLabelView.h"

@interface PublicMutableLabelView ()

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *edgeSource;

@end

@implementation PublicMutableLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showVerticalSeparator = YES;
    }
    return self;
}

- (void)updateDataSourceWithArray:(NSArray *)array {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self refreshContent];
}

- (void)updateEdgeSourceWithArray:(NSArray *)array {
    [self.edgeSource removeAllObjects];
    [self.edgeSource addObjectsFromArray:array];
    [self refreshContent];
}

- (void)refreshContent {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self.showViews removeAllObjects];
//    [self addSubview:NewSeparatorLine(CGRectMake(0, 0, self.width, appSeparaterLineSize))];
    
    NSArray *m_array = [NSArray arrayWithArray:self.dataSource];
    NSUInteger count = m_array.count;
    if (self.edgeSource.count != count) {
        for (NSUInteger i = 0; i < count; i++) {
            [self.edgeSource addObject:@(1.0 / count)];
        }
    }
    
    CGFloat x = 0;
//    if (self.labelAlignment == PublicMutableLabelAlignmentRight) {
//        x = self.width - width * count;
//    }
    for (NSUInteger i = 0; i < count; i++) {
        if (i < count) {
            CGFloat width = self.width * [self.edgeSource[i] floatValue];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, self.height)];
            btn.left = x;
            x += width;
            [btn setTitle:m_array[i] forState:UIControlStateNormal];
            [btn setTitleColor:baseTextColor forState:UIControlStateNormal];
            btn.titleLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            [self addSubview:btn];
            [self.showViews addObject:btn];
            
            if (btn.left != 0.0 && self.showVerticalSeparator) {
                [self addSubview:NewSeparatorLine(CGRectMake(btn.left, 0, appSeparaterLineSize, self.height))];
            }
        }
    }
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)edgeSource {
    if (!_edgeSource) {
        _edgeSource = [NSMutableArray new];
    }
    return _edgeSource;
}

- (NSMutableArray *)showViews {
    if (!_showViews) {
        _showViews = [NSMutableArray new];
    }
    return _showViews;
}

@end
