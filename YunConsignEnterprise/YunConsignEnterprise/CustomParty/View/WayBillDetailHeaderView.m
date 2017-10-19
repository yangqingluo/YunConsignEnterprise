//
//  WayBillDetailHeaderView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillDetailHeaderView.h"

@interface WayBillDetailHeaderView ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *contentImageView;

@end

@implementation WayBillDetailHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.width = screen_width;
        self.height = 160 + kEdge + self.footerView.height;
        [self setupHeader];
        [self setupContent];
    }
    return self;
}

- (void)setupHeader {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kEdge, self.width, 40)];
    _headerView.backgroundColor = AuxiliaryColor;
    [self addSubview:_headerView];
    
    _numberLabel = NewLabel(CGRectMake(kEdge, 0, _headerView.width - 2 * kEdge, _headerView.height), [UIColor whiteColor], [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    [_headerView addSubview:_numberLabel];
    
    self.footerView.bottom = self.height;
    [self addSubview:self.footerView];
}

- (void)setupContent {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.width, self.footerView.top - self.headerView.bottom)];
    _contentView.backgroundColor = MainColor;
    [self addSubview:_contentView];
    
    _dateLabel = NewLabel(CGRectMake(kEdge, 0, _contentView.width - 2 * kEdge, DEFAULT_BAR_HEIGHT), [UIColor whiteColor], [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    [_contentView addSubview:_dateLabel];
    [_contentView addSubview:NewSeparatorLine(CGRectMake(0, _dateLabel.bottom, _contentView.width, appSeparaterLineSize))];
    
    _urgentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_icon_urgent"]];
    _urgentImageView.top = _dateLabel.top;
    _urgentImageView.right = 0.9 * _contentView.width;
    _urgentImageView.hidden = YES;
    [_contentView addSubview:_urgentImageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_icon_direction_w"]];
    imageView.center = CGPointMake(0.5 * _contentView.width, _dateLabel.bottom + 0.5 * (_contentView.height - _dateLabel.bottom));
    [_contentView addSubview:imageView];
    _contentImageView = imageView;
    
    CGFloat m_edge = kEdge;
    _senderDetailLabel = NewLabel(CGRectMake(m_edge, _dateLabel.bottom, imageView.left - m_edge, _contentView.height - _dateLabel.bottom), [UIColor whiteColor], nil, NSTextAlignmentCenter);
    _senderDetailLabel.numberOfLines = 0;
    _senderDetailLabel.textAlignment = NSTextAlignmentLeft;
    [_contentView addSubview:_senderDetailLabel];
    
    _receiverDetailLabel = NewLabel(CGRectMake(imageView.right, _senderDetailLabel.top, _contentView.right - m_edge - (imageView.right), _senderDetailLabel.height), [UIColor whiteColor], nil, NSTextAlignmentCenter);
    _receiverDetailLabel.numberOfLines = 0;
    _receiverDetailLabel.textAlignment = NSTextAlignmentRight;
    [_contentView addSubview:_receiverDetailLabel];
    
//    [self refreshSenderDetailLabel];
//    [self refreshReceiverDetailLabel];
}

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        UIImageView *content_serration = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width * 8.0 / 344.0)];
        content_serration.image = [UIImage imageNamed:@"content_serration"];
        
        _footerView = [[UIView alloc] initWithFrame:content_serration.bounds];
        [_footerView addSubview:content_serration];
    }
    return _footerView;
}

#pragma mark - setter
- (void)setData:(AppWayBillDetailInfo *)data {
    _data = data;
    
    self.numberLabel.text = [NSString stringWithFormat:@"运单号： %@/%@", data.waybill_number, data.goods_number];
    self.dateLabel.text = [NSString stringWithFormat:@"时间：%@", dateStringWithTimeString(data.operate_time)];
    self.urgentImageView.hidden = !isTrue(data.is_urgent);
    
    [self refreshDetailLabel:self.senderDetailLabel text:[NSString stringWithFormat:@"%@-%@\n",data.start_station_city_name, data.start_station_service_name] subText:[NSString stringWithFormat:@"%@-%@", data.shipper_name, data.shipper_phone]];
    [self refreshDetailLabel:self.receiverDetailLabel text:[NSString stringWithFormat:@"%@-%@\n",data.end_station_city_name, data.end_station_service_name] subText:[NSString stringWithFormat:@"%@-%@", data.consignee_name, data.consignee_phone]];
}

- (void)refreshDetailLabel:(UILabel *)label text:(NSString *)text subText:(NSString *)subText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kEdge;
    NSDictionary *dic1 = @{NSFontAttributeName:[AppPublic boldAppFontOfSize:appLabelFontSizeMiddle]};
    NSDictionary *dic2 = @{NSFontAttributeName:[AppPublic appFontOfSize:appLabelFontSizeSmall]};
    NSDictionary *dic3 = @{NSFontAttributeName:[AppPublic appFontOfSize:0], NSParagraphStyleAttributeName : paragraphStyle};
    NSMutableAttributedString *m_string = [NSMutableAttributedString new];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:dic3]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:subText attributes:dic2]];
    label.attributedText = m_string;
}
@end
