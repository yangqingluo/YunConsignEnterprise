//
//  PublicSelectionVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/15.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "PublicSelectionVC.h"

#import "TitleTextCell.h"

@interface PublicSelectionVC ()


@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, assign) NSUInteger maxSelectCount;

@end

@implementation PublicSelectionVC

- (instancetype)initWithDataSource:(NSArray *)data selectedArray:(NSArray *)selectdArray maxSelectCount:(NSUInteger)count back:(DoneBlock)block{
    self = [super init];
    if (self) {
        self.dataSource = [data copy];
        
        self.selectedArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
        for (int i = 0; i < self.dataSource.count; i++) {
            [self.selectedArray addObject:@NO];
        }
        
        for (NSString *object in selectdArray) {
            int index = [object intValue];
            if (index < self.selectedArray.count && index >= 0) {
                self.selectedArray[index] = @YES;
            }
        }
        
        self.maxSelectCount = count;
        if (count == 0) {
            self.maxSelectCount = self.dataSource.count;
        }
        self.doneBlock = block;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : @"请选择" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"确定", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
    
}

- (void)goBack {
    [self doPopViewControllerAnimated:YES];
}

- (void)saveButtonAction {
    NSUInteger selectdCount = 0;
    for (NSNumber *number in self.selectedArray) {
        if ([number boolValue]) {
            selectdCount++;
        }
    }
    if (selectdCount == 0) {
        [self doShowHintFunction:@"请至少选择一项"];
        return;
    }
    if (self.doneBlock) {
        NSMutableArray *m_array = [NSMutableArray new];
        for (int i = 0; i < self.selectedArray.count; i++) {
            NSNumber *object = self.selectedArray[i];
            if ([object boolValue]) {
                [m_array addObject:@(i)];
            }
        }
        self.doneBlock(m_array);
    }
    [self goBack];
}

- (NSUInteger)calculateSelectedCount{
    NSUInteger count = 0;
    for (NSNumber *object in self.selectedArray) {
        if ([object boolValue]) {
            count++;
        }
    }
    return count;
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return [TitleTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:self.dataSource[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"selection_cell";
    TitleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TitleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setTitle:self.dataSource[indexPath.row]];
    cell.accessoryType = [self.selectedArray[indexPath.row] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.maxSelectCount == 1) {
        for (NSUInteger i = 0; i < self.selectedArray.count; i++) {
            self.selectedArray[i] = @(i == indexPath.row);
        }
    }
    else {
        if ([self.selectedArray[indexPath.row] boolValue]) {
            self.selectedArray[indexPath.row] = @NO;
        }
        else {
            NSUInteger selectedCount = [self calculateSelectedCount];
            if (selectedCount < self.maxSelectCount) {
                self.selectedArray[indexPath.row] = @YES;
            }
            else {
                [self showHint:[NSString stringWithFormat:@"最多只能选择%d项", (int)self.maxSelectCount]];
            }
        }
    }
    
    [tableView reloadData];
}


@end
