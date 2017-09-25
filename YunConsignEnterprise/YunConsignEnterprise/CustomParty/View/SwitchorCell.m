//
//  SwitchorCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SwitchorCell.h"

@implementation SwitchorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _baseView = [[PublicSwitchorCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, self.contentView.height)];
        _baseView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_baseView];
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
