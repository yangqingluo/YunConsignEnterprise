//
//  SearchQuantityResultCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SearchQuantityResultCell.h"

@interface SearchQuantityResultCell ()

@end

@implementation SearchQuantityResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = screen_width / 3;
        _firstLabel = NewLabel(CGRectMake(0, 0, width, kCellHeightMiddle), nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentCenter);
        [self.contentView addSubview:_firstLabel];
        
        _secondLabel = NewLabel(CGRectMake(width, 0, width, _firstLabel.height), nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentCenter);
        [self.contentView addSubview:_secondLabel];
        
        _actionBtn = NewTextButton(@"  ", MainColor);
        _actionBtn.frame = CGRectMake(0, 0, 60, 30);
        _actionBtn.center = CGPointMake(2.5 * width, _firstLabel.centerY);
        [AppPublic roundCornerRadius:_actionBtn cornerRadius:kButtonCornerRadius];
        _actionBtn.layer.borderColor = MainColor.CGColor;
        _actionBtn.layer.borderWidth = 1.0;
        [self.contentView addSubview:_actionBtn];
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightMiddle;
}

#pragma mark - setter
- (void)setData:(AppGoodsQuantityInfo *)data {
    _data = data;
    if ([data isKindOfClass:[AppRouteGoodsQuantityInfo class]]) {
        AppRouteGoodsQuantityInfo *m_data = (AppRouteGoodsQuantityInfo *)data;
        self.firstLabel.text = m_data.route;
        self.secondLabel.text = m_data.quantity;
        [self.actionBtn setTitle:@"派车" forState:UIControlStateNormal];
    }
    else if ([data isKindOfClass:[AppServiceGoodsQuantityInfo class]]) {
        AppServiceGoodsQuantityInfo *m_data = (AppServiceGoodsQuantityInfo *)data;
        self.firstLabel.text = m_data.service_name;
        self.secondLabel.text = m_data.quantity;
        [self.actionBtn setTitle:@"详情" forState:UIControlStateNormal];
    }
}
@end
