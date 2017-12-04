//
//  NormalTableViewCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "NormalTableViewCell.h"

@implementation NormalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, self.contentView.width - 2 * kEdgeMiddle, 0.5 * self.contentView.height), baseTextColor, nil, NSTextAlignmentLeft);
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = NewLabel(CGRectMake(kEdgeMiddle, self.titleLabel.bottom, self.contentView.width - 2 * kEdgeMiddle, 0.5 * self.contentView.height), secondaryTextColor, nil, NSTextAlignmentLeft);
        [self.contentView addSubview:_subTitleLabel];
        
        _rightTitleLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, self.contentView.width - 2 * kEdgeMiddle, 0.5 * self.contentView.height), secondaryTextColor, nil, NSTextAlignmentRight);
        [self.contentView addSubview:_rightTitleLabel];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(kEdgeMiddle, 0, self.contentView.width - 2 * kEdgeMiddle, 0.5 * self.contentView.height);
    _subTitleLabel.frame = CGRectMake(kEdgeMiddle, self.titleLabel.bottom, self.contentView.width - 2 * kEdgeMiddle, 0.5 * self.contentView.height);
    _rightTitleLabel.frame = _titleLabel.frame;
}

@end
