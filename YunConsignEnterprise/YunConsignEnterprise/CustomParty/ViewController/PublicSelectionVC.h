//
//  PublicSelectionVC.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/15.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "AppBasicTableViewController.h"

@interface PublicSelectionVC : AppBasicTableViewController

- (instancetype)initWithDataSource:(NSArray *)data selectedArray:(NSArray *)selectdArray maxSelectCount:(NSUInteger)count back:(DoneBlock)block;

@end
