//
//  TextFieldCell.h
//  BeaconConfig
//
//  Created by yangqingluo on 16/10/18.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexPathTextField : UITextField

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@interface TextFieldCell : UITableViewCell

@property (strong, nonatomic) IndexPathTextField *textField;

@end
