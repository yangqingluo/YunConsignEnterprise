//
//  SingleInputCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SingleInputCell.h"

@implementation SingleInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _inputView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeSmall, screen_width - 2 * kEdgeMiddle, self.contentView.height - 2 * kEdgeSmall)];
        _inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_inputView];
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
