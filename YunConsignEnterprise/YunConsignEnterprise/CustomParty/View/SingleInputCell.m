//
//  SingleInputCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SingleInputCell.h"

#define SingleInputATypeObserverKey @"accessoryType"

@implementation SingleInputCell

- (void)dealloc {
    [self removeObserver:self forKeyPath:SingleInputATypeObserverKey];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _baseView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, self.contentView.height)];
        _baseView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_baseView];
        
        [self addObserver:self forKeyPath:SingleInputATypeObserverKey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath rightString:(NSString *)rightString {
    PublicInputCellView *m_view = [[PublicInputCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, 0)];
    return [self tableView:tableView heightForRowAtIndexPath:indexPath withRightTitle:rightString rightTitleFont:m_view.textField.font rightWidth:m_view.textField.width];
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
    if([keyPath isEqualToString:SingleInputATypeObserverKey]){
        if (self.accessoryType == UITableViewCellAccessoryNone) {
            if (self.baseView.rightView) {
                self.baseView.textField.width = self.baseView.rightView.left - cellDetailLeft;
            }
            else {
                self.baseView.textField.width = self.baseView.width - cellDetailLeft;
            }
        }
        else {
            //UITableViewCellAccessoryDisclosureIndicator下baseView.rightView暂时没有同时存在的情况
            self.baseView.textField.width = self.baseView.width - cellDetailLeft - kEdgeHuge + (screen_width - self.baseView.right);
        }
    }
}

@end
