//
//  PublicResultWithScrollTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/26.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicResultWithScrollTableVC.h"

@interface PublicResultWithScrollTableVC ()

@end

@implementation PublicResultWithScrollTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.scrollView atIndex:0];
    CGFloat scale = 5.0f + 2.0 * self.condition.show_column.count;
    if (self.type != PublicResultWithScrollTableType_DEFAULT) {
        scale = 7.0f + 2.0 * self.condition.show_column.count;
    }
    
    //如果存在备注的话，备注栏增加2.0宽度
    BOOL hasNote = NO;
    CGFloat noteEdge = 4.0;
    for (AppDataDictionary *item in self.condition.show_column) {
        if ([item.item_val isEqualToString:@"note"]) {
            hasNote = YES;
            break;
        }
    }
    if (hasNote) {
        scale += (noteEdge - 2.0);
    }
    
    [self.edgeArray addObject:@(1.0 / scale)];
    [self.edgeArray addObject:@(4.0 / scale)];
    if (self.type != PublicResultWithScrollTableType_DEFAULT) {
        [self.edgeArray addObject:@(2.0 / scale)];
    }
    
    for (AppDataDictionary *item in self.condition.show_column) {
        [self.valArray addObject:item.item_val];
        [self.nameArray addObject:item.item_name];
        [self.edgeArray addObject:@(([item.item_val isEqualToString:@"note"] ? noteEdge : 2.0) / scale)];
    }
    
    CGFloat contentWidth = MAX(screen_width, 38 * scale);
    self.tableView.width = contentWidth;
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.height);
    
    [self.scrollView addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (UIScrollView *)scrollView {
    if (_scrollView == nil){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight |  UIViewAutoresizingFlexibleWidth;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    
    return _scrollView;
}

- (NSMutableArray *)valArray {
    if (!_valArray) {
        _valArray = [NSMutableArray new];
    }
    return _valArray;
}

- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSMutableArray new];
    }
    return _nameArray;
}

- (NSMutableArray *)edgeArray {
    if (!_edgeArray) {
        _edgeArray = [NSMutableArray new];
    }
    return _edgeArray;
}

@end
