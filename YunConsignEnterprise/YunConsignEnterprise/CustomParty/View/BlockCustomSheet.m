//
//  BlockCustomSheet.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/5/31.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "BlockCustomSheet.h"

@interface BlockCustomSheet () {
    CGFloat itemHeight;
    NSInteger maxShowRows;
}

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation BlockCustomSheet

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        itemHeight = kCellHeight;
        maxShowRows = 4;
        self.hidden = YES;
        self.delegate = self;
        self.dataSource = self;
        //        self.layer.shadowColor = [UIColor blackColor].CGColor;
        //        self.layer.shadowOffset = CGSizeMake(0, 0);
        //        self.layer.shadowOpacity = 0.8;
        //        self.layer.shadowRadius = 4.0;
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = baseSeparatorAlphaColor.CGColor;
        self.backgroundColor = RGBA(0xf0, 0xff, 0xff, 1.0);
        self.separatorColor = baseSeparatorAlphaColor;
    }
    return self;
}

- (void)showWithStringArray:(NSArray<NSString *> *)array {
    self.height = MIN(array.count, maxShowRows) * itemHeight;
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:array];
    [self reloadData];
    [self show];
}

- (void)show {
    self.hidden = NO;
}

- (void)dismiss {
    self.hidden = YES;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (![super pointInside:point withEvent:event]) {
        [self dismiss];
    }
    return YES;
}

#pragma  mark - getter
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return itemHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"sheet_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.block) {
        self.block(indexPath.row);
    }
    [self dismiss];
}

@end
