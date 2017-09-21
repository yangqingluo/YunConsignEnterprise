//
//  PublicInputCellView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldCell.h"

@interface IndexPathButton : UIButton

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@interface PublicInputCellView : UIView

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) IndexPathTextField *textField;
@property (strong, nonatomic) IndexPathButton *rightButton;

- (void)showRightButtonWithImage:(UIImage *)image;

@end
