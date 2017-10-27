//
//  DoubleInputCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DoubleInputCell.h"

@implementation DoubleInputCell

- (void)dealloc {
    [self.baseView.textLabel removeObserver:self forKeyPath:@"text"];
    [self.anotherBaseView.textLabel removeObserver:self forKeyPath:@"text"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _baseView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, 0.5 * screen_width - 2 * kEdgeMiddle, self.contentView.height)];
        _baseView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _baseView.textField.tag = 0;
        [self.contentView addSubview:_baseView];
        
        _anotherBaseView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(0.5 * screen_width + kEdgeMiddle, 0, 0.5 * screen_width - 2 * kEdgeMiddle, self.contentView.height)];
        _anotherBaseView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _anotherBaseView.textField.tag = 1;
        [self.contentView addSubview:_anotherBaseView];
        
        [self.baseView.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        [self.anotherBaseView.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
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

- (void)adjustBaseView:(PublicInputCellView *)m_view {
    [AppPublic adjustLabelWidth:m_view.textLabel];
    m_view.textField.left = m_view.textLabel.right + kEdge;
    if (m_view.rightView) {
        m_view.textField.width = m_view.rightView.left - kEdgeSmall - m_view.textField.left;
    }
    else {
        m_view.textField.width = m_view.width - kEdgeSmall - m_view.textField.left;
    }
}

#pragma mark - setter
- (void)setIsShowBottomEdge:(BOOL)isShowBottomEdge {
    _isShowBottomEdge = isShowBottomEdge;
    if (_isShowBottomEdge) {
//        self.baseView.height = self.contentView.height - kEdge;
//        self.anotherBaseView.height = self.contentView.height - kEdge;
        self.baseView.lineView.bottom = self.baseView.height - kEdge;
        self.anotherBaseView.lineView.bottom = self.baseView.height - kEdge;
    }
    else {
//        self.baseView.height = self.contentView.height;
//        self.anotherBaseView.height = self.contentView.height;
        self.baseView.lineView.bottom = self.baseView.height;
        self.anotherBaseView.lineView.bottom = self.baseView.height;
    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        if ([object isEqual:self.baseView.textLabel]) {
            [self adjustBaseView:self.baseView];
        }
        else if ([object isEqual:self.anotherBaseView.textLabel]) {
            [self adjustBaseView:self.anotherBaseView];
        }
    }
}
@end
