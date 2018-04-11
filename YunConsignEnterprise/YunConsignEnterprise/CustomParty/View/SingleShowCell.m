//
//  SingleShowCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/4/11.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "SingleShowCell.h"

#define SingleShowATypeObserverKey @"accessoryType"

@implementation SingleShowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _baseView = [[PublicCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, self.contentView.height)];
        _baseView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_baseView];
        
        _baseView.subTextLabel = NewLabel(CGRectMake(cellDetailLeft, 0, _baseView.width - cellDetailLeft, _baseView.height), nil, nil, NSTextAlignmentRight);
        _baseView.subTextLabel.numberOfLines = 0;
        [_baseView addSubview:_baseView.subTextLabel];
        _baseView.subTextLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [self addObserver:self forKeyPath:SingleShowATypeObserverKey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath rightString:(NSString *)rightString type:(UITableViewCellAccessoryType)aType {
    CGFloat m_width = 0;
    if (aType == UITableViewCellAccessoryNone) {
        m_width = screen_width - 2 * kEdgeMiddle - cellDetailLeft;
    }
    else {
        m_width = screen_width - 2 * kEdgeMiddle - cellDetailLeft - kEdgeHuge + kEdgeMiddle;
    }
    return [self tableView:tableView heightForRowAtIndexPath:indexPath withRightTitle:rightString rightTitleFont:[AppPublic appFontOfSize:appLabelFontSize] rightWidth:m_width];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withRightTitle:(NSString *)rTitle rightTitleFont:(UIFont *)rTitleFont rightWidth:(CGFloat)rWidth {
    CGFloat height = kEdge + [AppPublic textSizeWithString:rTitle font:rTitleFont constantWidth:rWidth].height + kEdge;
    return MAX(kCellHeightFilter, height);
}

#pragma mark - setter
- (void)setIsShowBottomEdge:(BOOL)isShowBottomEdge {
    _isShowBottomEdge = isShowBottomEdge;
    if (_isShowBottomEdge) {
        //        self.baseView.height = self.contentView.height - kEdge;
        self.baseView.lineView.bottom = self.baseView.height - kEdge;
    }
    else {
        //        self.baseView.height = self.contentView.height;
        self.baseView.lineView.bottom = self.baseView.height;
    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:SingleShowATypeObserverKey]){
        if (self.accessoryType == UITableViewCellAccessoryNone) {
            self.baseView.subTextLabel.width = self.baseView.width - cellDetailLeft;
        }
        else {
            self.baseView.subTextLabel.width = self.baseView.width - cellDetailLeft - kEdgeHuge + (screen_width - self.baseView.right);
        }
    }
}

@end
