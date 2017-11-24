//
//  FourItemsListCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FourItemsListCell.h"

@interface FourItemsListCell ()

@end

@implementation FourItemsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, kCellHeightHuge - kEdge)];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.borderColor = baseSeparatorColor.CGColor;
        _baseView.layer.borderWidth = 1.0;
        [AppPublic roundCornerRadius:_baseView cornerRadius:kViewCornerRadius];
        [self.contentView addSubview:_baseView];
        
        UIView *lineView = NewSeparatorLine(CGRectMake(0, 0.5 * _baseView.height, _baseView.width, 1.0));
        lineView.centerY = 0.5 * _baseView.height;
        [_baseView addSubview:lineView];
        
        _firstLeftLabel = NewLabel(CGRectMake(kEdge, 0, 0.5 * _baseView.width - 2 * kEdge, 0.5 * _baseView.height), nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
        [_baseView addSubview:_firstLeftLabel];
        
        _firstRightLabel = NewLabel(_firstLeftLabel.frame, nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentRight);
        _firstRightLabel.left = 0.5 * _baseView.width + _firstLeftLabel.left;
        [_baseView addSubview:_firstRightLabel];
        
        _secondLeftLabel = NewLabel(CGRectMake(kEdge, 0.5 * _baseView.height, 0.5 * _baseView.width - 2 * kEdge, 0.5 * _baseView.height), nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
        [_baseView addSubview:_secondLeftLabel];
        
        _secondRightLabel = NewLabel(_secondLeftLabel.frame, nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentRight);
        _secondRightLabel.left = 0.5 * _baseView.width + _secondLeftLabel.left;
        [_baseView addSubview:_secondRightLabel];
        
        _firstLeftLabel.numberOfLines = 0;
        _firstRightLabel.numberOfLines = 0;
        _secondLeftLabel.numberOfLines = 0;
        _secondRightLabel.numberOfLines = 0;
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
    return kCellHeightHuge;
}

@end
