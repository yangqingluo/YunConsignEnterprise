//
//  PublicHeaderContentFooterCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@implementation PublicHeaderBodyFooterCell

- (instancetype)initWithHeaderStyle:(PublicHeaderCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithHeaderStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupFooter];
    }
    
    return self;
}

- (void)setupFooter {
    _footerView = [[PublicMutableButtonView alloc] initWithFrame:CGRectMake(0, self.baseView.height - kCellHeightSmall, self.baseView.width, kCellHeightSmall)];
    _footerView.showTopHorizontalSeparator = YES;
    _footerView.defaultWidthScale = 1.0 / 4;
    _footerView.mutableContentAlignment = PublicMutableContentAlignmentRight;
    [self.baseView addSubview:_footerView];
    
    self.footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath] + kCellHeightSmall;
}

#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath {
    super.indexPath = indexPath;
    if (self.footerView) {
        self.footerView.indexPath = [indexPath copy];
    }
}
@end
