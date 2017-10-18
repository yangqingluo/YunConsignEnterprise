//
//  PublicHeaderContentFooterCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

#define height_PublicHeaderBodyFooterCell 200.0

@implementation PublicHeaderBodyFooterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeSmall, screen_width - 2 * kEdgeMiddle, height_PublicHeaderBodyFooterCell - 2 * kEdgeSmall)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_baseView];
        
        [AppPublic roundCornerRadius:_baseView cornerRadius:kViewCornerRadius];
        _baseView.layer.borderColor = baseSeparatorColor.CGColor;
        _baseView.layer.borderWidth = appSeparaterLineSize;
        
        [self setupHeader];
        [self setupFooter];
        [self setupBody];
    }
    
    return self;
}

- (void)setupHeader {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseView.width, 32)];
    _headerView.backgroundColor = RGBA(0xf4, 0xfb, 0xfc, 1.0);
    [self.baseView addSubview:_headerView];
    
    [_headerView addSubview:NewSeparatorLine(CGRectMake(0, _headerView.height - appSeparaterLineSize, _headerView.width, appSeparaterLineSize))];
    
    _titleLabel = NewLabel(CGRectMake(kEdge, 0, 0.5 * _headerView.width, _headerView.height), nil, nil, NSTextAlignmentLeft);
    [_headerView addSubview:_titleLabel];
    
    _statusLabel = NewLabel(CGRectMake(_headerView.width - kEdge - 200, 0, 200, _headerView.height), secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentRight);
    [_headerView addSubview:_statusLabel];
}

- (void)setupFooter {
    _footerView = [[PublicMutableButtonView alloc] initWithFrame:CGRectMake(0, self.baseView.height - 32, self.baseView.width, 32)];
    _footerView.showTopHorizontalSeparator = YES;
    _footerView.defaultWidthScale = 1.0 / 4;
    _footerView.mutableContentAlignment = PublicMutableContentAlignmentRight;
    [self.baseView addSubview:_footerView];
}

- (void)setupBody {
    _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.baseView.width, self.footerView.top - self.headerView.bottom)];
    [self.baseView addSubview:_bodyView];
    
    _bodyLabel1 = NewLabel(CGRectMake(kEdge, kEdgeBig, _bodyView.width - 2 * kEdge, 24), nil, nil, NSTextAlignmentLeft);
    //    _bodyLabel1.adjustsFontSizeToFitWidth = YES;
    [_bodyView addSubview:_bodyLabel1];
    
    _bodyLabel2 = NewLabel(_bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel2.top = _bodyLabel1.bottom + kEdgeMiddle;
    [_bodyView addSubview:_bodyLabel2];
    
    _bodyLabel3 = NewLabel(_bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel3.top = _bodyLabel2.bottom + kEdgeMiddle;
    [_bodyView addSubview:_bodyLabel3];
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
    return height_PublicHeaderBodyFooterCell;
}

#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (self.footerView) {
        self.footerView.indexPath = [indexPath copy];
    }
}
@end
