//
//  WayBillSRHeaderView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillSRHeaderView.h"

@interface WayBillSRHeaderView ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *contentImageView;

@end

@implementation WayBillSRHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupHeader];
        [self setupContent];
    }
    return self;
}

- (void)setupHeader {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    [self addSubview:_headerView];
    
    CGFloat leftSX = (4.0 / 17.0) * _headerView.width;
    CGFloat rightSX = (13.0 / 17.0) * _headerView.width;
    [_headerView addSubview:NewSeparatorLine(CGRectMake(0, 0, _headerView.width, 1.0))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(0, _headerView.height - 1, _headerView.width, 1.0))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(leftSX , 0, 1.0, _headerView.height))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(rightSX, 0, 1.0, _headerView.height))];
    
    _dateLabel = NewLabel(CGRectMake(leftSX, 0, rightSX - leftSX, _headerView.height), nil, nil, NSTextAlignmentCenter);
    [_headerView addSubview:_dateLabel];
    
    _senderLabel = NewLabel(CGRectMake(0, 0, leftSX - 0, _headerView.height), secondaryTextColor, [AppPublic appFontOfSize:12.0], NSTextAlignmentCenter);
    [_headerView addSubview:_senderLabel];
    
    _receiverLabel = NewLabel(CGRectMake(rightSX, 0, _headerView.width - rightSX, _headerView.height), secondaryTextColor, [AppPublic appFontOfSize:12.0], NSTextAlignmentCenter);
    [_headerView addSubview:_receiverLabel];
    
    self.dateLabel.text = stringFromDate([NSDate date], @"yyyy年MM月dd日");
    self.senderLabel.text = @"发货人";
    self.senderLabel.hidden = YES;
    self.receiverLabel.text = @"收货人";
    self.receiverLabel.hidden = YES;
}

- (void)setupContent {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.width, self.height - self.headerView.bottom)];
    [self addSubview:_contentView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_icon_direction"]];
    imageView.center = CGPointMake(0.5 * _contentView.width, 0.5 * _contentView.height);
    [_contentView addSubview:imageView];
    _contentImageView = imageView;
    
    CGFloat m_edge = kEdgeHuge;
    _senderDetailLabel = NewLabel(CGRectMake(m_edge, 0, imageView.left - 2 * m_edge, _contentView.height), nil, nil, NSTextAlignmentCenter);
    _senderDetailLabel.numberOfLines = 0;
    [_contentView addSubview:_senderDetailLabel];
    
    _senderButton = [[UIButton alloc] initWithFrame:CGRectMake(kEdge, kEdge, imageView.left - 2 * kEdge, _contentView.height - 2 * kEdge)];
    [_senderButton setImage:[UIImage dottedLineImageWithSize:CGSizeMake(92, 60) borderColor:baseSeparatorColor borderWidth:1.0] forState:UIControlStateSelected];
    [_contentView addSubview:_senderButton];
    
    [self refreshSenderDetailLabel];
}

- (void)refreshSenderDetailLabel {
    BOOL hasSenderInfo = (self.senderInfo != nil);
    self.senderLabel.hidden = !hasSenderInfo;
    self.senderButton.selected = !hasSenderInfo;
    self.senderDetailLabel.width = hasSenderInfo ? self.contentImageView.left - self.senderDetailLabel.left : self.contentImageView.left - 2 * self.senderDetailLabel.left;
    if (hasSenderInfo) {
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle1.lineSpacing = 0.0;
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle2.lineSpacing = kEdge;
        NSDictionary *dic1 = @{NSFontAttributeName:[AppPublic appFontOfSize:16], NSForegroundColorAttributeName:baseTextColor, NSParagraphStyleAttributeName : paragraphStyle1};
        NSDictionary *dic2 = @{NSFontAttributeName:[AppPublic appFontOfSize:14], NSForegroundColorAttributeName:baseTextColor, NSParagraphStyleAttributeName : paragraphStyle2};
        NSDictionary *dic3 = @{NSFontAttributeName:[AppPublic appFontOfSize:0], NSForegroundColorAttributeName:baseTextColor, NSParagraphStyleAttributeName : paragraphStyle2};
        
        NSMutableAttributedString *m_string = [NSMutableAttributedString new];
        [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@-%@\n", self.senderInfo.service.open_city_name, self.senderInfo.service.service_name] attributes:dic1]];
        [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:dic3]];
        [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", self.senderInfo.customer.freight_cust_name, self.senderInfo.customer.phone] attributes:dic2]];
        self.senderDetailLabel.attributedText = m_string;
    }
    else {
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle1.lineSpacing = 0.0;
        paragraphStyle1.alignment = NSTextAlignmentCenter;
        NSDictionary *dic1 = @{NSFontAttributeName:[AppPublic appFontOfSize:16], NSForegroundColorAttributeName:secondaryTextColor, NSParagraphStyleAttributeName : paragraphStyle1};
        self.senderDetailLabel.attributedText = [[NSAttributedString alloc] initWithString:@"发货人" attributes:dic1];
    }
}

#pragma mark - setter
- (void)setSenderInfo:(AppSendReceiveInfo *)senderInfo {
    _senderInfo = senderInfo;
    [self refreshSenderDetailLabel];
}

@end
