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

@end

@implementation PublicMutableLabelView

- (void)updateDataSourceWithArray:(NSArray *)array {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self refreshContent];
}

- (void)refreshContent {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
//    [self addSubview:NewSeparatorLine(CGRectMake(0, 0, self.width, appSeparaterLineSize))];
    
    NSArray *m_array = [NSArray arrayWithArray:self.dataSource];
    
    NSUInteger count = m_array.count;
    CGFloat width = self.width / count;
    CGFloat x = 0;
//    if (self.labelAlignment == PublicMutableLabelAlignmentRight) {
//        x = self.width - width * count;
//    }
    for (NSUInteger i = 0; i < count; i++) {
        if (i < count) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, self.height)];
            btn.left = x + i * width;
            [btn setTitle:m_array[i] forState:UIControlStateNormal];
            [btn setTitleColor:baseTextColor forState:UIControlStateNormal];
            btn.titleLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            [self addSubview:btn];
            
            if (btn.left != 0.0) {
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

@end
