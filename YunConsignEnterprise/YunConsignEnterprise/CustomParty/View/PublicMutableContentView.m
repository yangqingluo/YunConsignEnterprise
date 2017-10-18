//
//  PublicMutableContentView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicMutableContentView.h"

@interface PublicMutableContentView ()

@end

@implementation PublicMutableContentView

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
//    [self refreshContent];
}

- (void)refreshContent {
    
}

- (void)refreshHorizontalSeparators {
    if (self.showTopHorizontalSeparator) {
        [self addSubview:NewSeparatorLine(CGRectMake(0, 0, self.width, appSeparaterLineSize))];
    }

    if (self.showBottomHorizontalSeparator) {
        [self addSubview:NewSeparatorLine(CGRectMake(0, self.height - appSeparaterLineSize, self.width, appSeparaterLineSize))];
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
