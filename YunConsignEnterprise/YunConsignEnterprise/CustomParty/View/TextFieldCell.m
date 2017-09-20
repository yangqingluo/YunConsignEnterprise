//
//  TextFieldCell.m
//  BeaconConfig
//
//  Created by yangqingluo on 16/10/18.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "TextFieldCell.h"

@implementation IndexPathTextField



@end

@implementation TextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField = [[IndexPathTextField alloc]initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, 40)];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.centerY = 0.5 * kCellHeightMiddle;
        self.textField.font = [UIFont systemFontOfSize:appLabelFontSize];
        [self.contentView addSubview:self.textField];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
