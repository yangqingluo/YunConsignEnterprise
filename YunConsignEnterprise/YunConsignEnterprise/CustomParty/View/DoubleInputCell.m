//
//  DoubleInputCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DoubleInputCell.h"

@implementation DoubleInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _inputView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, 0.5 * screen_width - 2 * kEdgeMiddle, self.contentView.height)];
        _inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _inputView.textField.tag = 0;
        [self.contentView addSubview:_inputView];
        
        _anotherInputView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(0.5 * screen_width + kEdgeMiddle, 0, 0.5 * screen_width - 2 * kEdgeMiddle, self.contentView.height)];
        _anotherInputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _anotherInputView.textField.tag = 1;
        [self.contentView addSubview:_anotherInputView];
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

#pragma mark - setter
- (void)setIsShowBottomEdge:(BOOL)isShowBottomEdge {
    _isShowBottomEdge = isShowBottomEdge;
    if (_isShowBottomEdge) {
        self.inputView.height = self.contentView.height - kEdge;
        self.anotherInputView.height = self.contentView.height - kEdge;
    }
    else {
        self.inputView.height = self.contentView.height;
        self.anotherInputView.height = self.contentView.height;
    }
}

@end
