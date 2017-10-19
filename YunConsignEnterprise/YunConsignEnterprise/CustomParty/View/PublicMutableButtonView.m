//
//  PublicMutableButtonView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicMutableButtonView.h"

#import "UIResponder+Router.h"

@interface PublicMutableButtonView ()

@end

@implementation PublicMutableButtonView

- (void)refreshContent {
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
    if (self.mutableContentAlignment == PublicMutableContentAlignmentRight) {
        for (NSUInteger i = 0; i < count; i++) {
            CGFloat width = self.width * [self.edgeSource[i] floatValue];
            x += width;
        }
        x = self.width - x;
    }
    for (NSUInteger i = 0; i < count; i++) {
        if (i < count) {
            CGFloat width = self.width * [self.edgeSource[i] floatValue];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, self.height)];
            btn.left = x;
            x += width;
            [btn setTitle:m_array[i] forState:UIControlStateNormal];
            [btn setTitleColor:secondaryTextColor forState:UIControlStateNormal];
            btn.titleLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            [self addSubview:btn];
            [self.showViews addObject:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (btn.left != 0.0 && self.showVerticalSeparator) {
                [self addSubview:NewSeparatorLine(CGRectMake(btn.left, 0, appSeparaterLineSize, self.height))];
            }
        }
    }
    [self refreshHorizontalSeparators];
}

- (void)btnAction:(UIButton *)button {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"tag" : @(button.tag)}];
    if (self.indexPath) {
        [m_dic setObject:self.indexPath forKey:@"indexPath"];
    }
    [self routerEventWithName:Event_PublicMutableButtonClicked userInfo:[NSDictionary dictionaryWithDictionary:m_dic]];
}

@end
