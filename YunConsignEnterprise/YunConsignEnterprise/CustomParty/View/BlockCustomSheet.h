//
//  BlockCustomSheet.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/5/31.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomSheetBlock)(NSInteger);

@interface BlockCustomSheet : UITableView

@property (copy, nonatomic) CustomSheetBlock block;

- (void)showWithStringArray:(NSArray<NSString *> *)array;
- (void)show;
- (void)dismiss;

@end
