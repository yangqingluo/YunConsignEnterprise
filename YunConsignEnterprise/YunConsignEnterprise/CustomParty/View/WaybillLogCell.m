//
//  WaybillLogCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/23.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLogCell.h"

@implementation WaybillLogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat m_height = kCellHeightBig;
        self.backgroundColor = [UIColor whiteColor];
        self.roundPointView = [[PublicRoundPointView alloc] initWithFrame:CGRectMake(0, 0, 28, 28) baseColor:RGBA(0x00, 0xbc, 0xd4, 0.4) secondaryColor:RGBA(0x00, 0x97, 0xa7, 0.8)];
        self.roundPointView.center = CGPointMake(120, 0.5 * m_height);
        [self.contentView addSubview:self.roundPointView];
        
        CGFloat lineHeight = 0.5 * (m_height - self.roundPointView.height - 2 * kEdge);
        self.upLineView = NewSeparatorLine(CGRectMake(0, 0, 2, lineHeight));
        self.upLineView.centerX = self.roundPointView.centerX;
        [self.contentView addSubview:self.upLineView];
        self.downLineView = NewSeparatorLine(CGRectMake(0, self.roundPointView.bottom + kEdge, 2, lineHeight));
        self.downLineView.centerX = self.roundPointView.centerX;
        [self.contentView addSubview:self.downLineView];
        
        self.leftLineView = NewSeparatorLine(CGRectMake(0, m_height - 1, self.downLineView.left - kEdge, 1));
        [self.contentView addSubview:self.leftLineView];
        self.rightLineView = NewSeparatorLine(CGRectMake(self.downLineView.right + kEdge, self.leftLineView.top, screen_width - (self.downLineView.right + kEdge), self.leftLineView.height));
        [self.contentView addSubview:self.rightLineView];
        
        self.timeLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, self.roundPointView.left - 2 * kEdgeMiddle, m_height), nil, nil, NSTextAlignmentCenter);
        self.timeLabel.numberOfLines = 0;
        [self.contentView addSubview:self.timeLabel];
        
        self.noteLabel = NewLabel(CGRectMake(self.roundPointView.right + kEdgeMiddle, 0, screen_width - self.roundPointView.right - 2 * kEdgeMiddle, m_height), nil, [AppPublic appFontOfSize:appLabelFontSize], NSTextAlignmentLeft);
        self.noteLabel.numberOfLines = 0;
        [self.contentView addSubview:self.noteLabel];
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
    return kCellHeightBig;
}

- (void)refreshDetailLabel:(UILabel *)label text:(NSString *)text subText:(NSString *)subText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kEdgeSmall;
    NSDictionary *dic1 = @{NSFontAttributeName:[AppPublic appFontOfSize:appLabelFontSize], NSForegroundColorAttributeName:baseTextColor};
    NSDictionary *dic2 = @{NSFontAttributeName:[AppPublic appFontOfSize:appLabelFontSizeSmall], NSForegroundColorAttributeName:secondaryTextColor};
    NSDictionary *dic3 = @{NSFontAttributeName:[AppPublic appFontOfSize:0], NSParagraphStyleAttributeName : paragraphStyle};
    NSMutableAttributedString *m_string = [NSMutableAttributedString new];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:dic3]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:subText attributes:dic2]];
    label.attributedText = m_string;
}

#pragma mark - setter
- (void)setData:(AppWaybillLogInfo *)data {
    _data = data;
    
    NSDate *follow_time = dateFromString(data.follow_time, @"yyyy-MM-dd HH:mm:ss");
    [self refreshDetailLabel:self.timeLabel text:[NSString stringWithFormat:@"%@\n", stringFromDate(follow_time, @"HH:mm")] subText:stringFromDate(follow_time, defaultDateFormat)];
    self.noteLabel.text = data.follow_note;
}

- (void)setIsShowTopEdge:(BOOL)isShowTopEdge {
    _isShowTopEdge = isShowTopEdge;
    self.upLineView.hidden = isShowTopEdge;
    [self.roundPointView updateBaseColor:isShowTopEdge ? RGBA(0x00, 0xbc, 0xd4, 0.4) : RGBA(0xdb, 0xdb, 0xdb, 0.4) secondaryColor:isShowTopEdge ? RGBA(0x00, 0x97, 0xa7, 0.8) : RGBA(0xc0, 0xc0, 0xc0, 0.8)];
}

- (void)setIsShowBottomEdge:(BOOL)isShowBottomEdge {
    _isShowBottomEdge = isShowBottomEdge;
    self.leftLineView.hidden = isShowBottomEdge;
    self.rightLineView.hidden = isShowBottomEdge;
    self.downLineView.hidden = isShowBottomEdge;
}
@end
