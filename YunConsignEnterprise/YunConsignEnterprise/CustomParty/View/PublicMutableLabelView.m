//
//  PublicMutableLabelListView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicMutableLabelView.h"

@interface PublicMutableLabelView ()


@end

@implementation PublicMutableLabelView

- (void)refreshContent {
    if (self.hasChangedForEdgeSource | self.hasChangedForDataSourceCount) {
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
        [self.showViews removeAllObjects];
        
        NSArray *m_array = [NSArray arrayWithArray:self.dataSource];
        NSUInteger count = m_array.count;
        if (self.edgeSource.count != count) {
            [self.edgeSource removeAllObjects];
            for (NSUInteger i = 0; i < count; i++) {
                [self.edgeSource addObject:@(self.defaultWidthScale == 0.0 ? 1.0 / count : self.defaultWidthScale)];
            }
        }
        
        CGFloat x = 0;
        for (NSUInteger i = 0; i < count; i++) {
            if (i < count) {
                CGFloat width = self.width * [self.edgeSource[i] floatValue];
                UILabel *label = NewLabel(CGRectMake(0, 0, width, self.height), baseTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentCenter);
                label.left = x;
                x += width;
                label.text = m_array[i];
//                label.numberOfLines = 0;
                label.autoresizingMask = YES;
                [self addSubview:label];
                [self.showViews addObject:label];
                
                if (label.left != 0.0 && self.showVerticalSeparator) {
                    [self addSubview:NewSeparatorLine(CGRectMake(label.left, 0, appSeparaterLineSize, self.height))];
                }
            }
        }
        [self refreshHorizontalSeparators];
    }
    else {
        for (NSUInteger i = 0; i < self.showViews.count; i++) {
            UILabel *m_label = self.showViews[i];
            m_label.text = self.dataSource[i];
        }
    }
}

@end
