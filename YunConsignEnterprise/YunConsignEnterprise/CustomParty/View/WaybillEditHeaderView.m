
//
//  WaybillEditHeaderView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillEditHeaderView.h"

@interface WaybillEditHeaderView ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *contentImageView;

@end

@implementation WaybillEditHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.width = screen_width;
        self.height = 200 + kEdge;
        [self setupHeader];
        [self setupContent];
    }
    return self;
}

- (void)setupHeader {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kEdge, self.width, 40 + kCellHeightFilter)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headerView];
    
    _titleView = [[WaybillTitleView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, kCellHeightFilter)];
    _titleView.textLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
    [_headerView addSubview:_titleView];
    
    CGFloat leftSX = (4.0 / 17.0) * _headerView.width;
    CGFloat rightSX = (13.0 / 17.0) * _headerView.width;
    CGFloat topSX = _titleView.bottom;
    CGFloat heightSX = _headerView.height - _titleView.bottom;
    
    [_headerView addSubview:NewSeparatorLine(CGRectMake(0, 0, _headerView.width, appSeparaterLineSize))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(0, _titleView.bottom - appSeparaterLineSize, _headerView.width, appSeparaterLineSize))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(0, _headerView.height - appSeparaterLineSize, _headerView.width, appSeparaterLineSize))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(leftSX , topSX, appSeparaterLineSize, heightSX))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(rightSX, topSX, appSeparaterLineSize, heightSX))];
    
    _dateLabel = NewLabel(CGRectMake(leftSX, topSX, rightSX - leftSX, heightSX), nil, nil, NSTextAlignmentCenter);
    [_headerView addSubview:_dateLabel];
    
    _senderLabel = NewLabel(CGRectMake(0, topSX, leftSX - 0, heightSX), secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentCenter);
    [_headerView addSubview:_senderLabel];
    
    _receiverLabel = NewLabel(CGRectMake(rightSX, topSX, _headerView.width - rightSX, heightSX), secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentCenter);
    [_headerView addSubview:_receiverLabel];
    
//    self.dateLabel.text = stringFromDate(self.date, @"yyyy年MM月dd日");
    self.senderLabel.text = @"发货人";
//    self.senderLabel.hidden = YES;
    self.receiverLabel.text = @"收货人";
//    self.receiverLabel.hidden = YES;
}

- (void)setupContent {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.width, self.height - self.headerView.bottom)];
    _contentView.backgroundColor = [UIColor whiteColor];
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
    
    _receiverDetailLabel = NewLabel(CGRectMake(imageView.right + m_edge, 0, _contentView.right - m_edge - (imageView.right + m_edge), _contentView.height), nil, nil, NSTextAlignmentCenter);
    _receiverDetailLabel.numberOfLines = 0;
    [_contentView addSubview:_receiverDetailLabel];
    
    _receiverButton = [[UIButton alloc] initWithFrame:CGRectMake(imageView.right + kEdge, kEdge, _contentView.right - kEdge - (imageView.right + kEdge), _contentView.height - 2 * kEdge)];
    [_receiverButton setImage:[UIImage dottedLineImageWithSize:CGSizeMake(92, 60) borderColor:baseSeparatorColor borderWidth:1.0] forState:UIControlStateSelected];
    [_contentView addSubview:_receiverButton];
    
    [_contentView addSubview:NewSeparatorLine(CGRectMake(0, _contentView.height - appSeparaterLineSize, _contentView.width, appSeparaterLineSize))];
    
    [self refreshSenderDetailLabel];
    [self refreshReceiverDetailLabel];
}

AppSendReceiveInfo *NewAppSendReceiveInfo(NSString *open_city_name, NSString *service_name, NSString *freight_cust_name, NSString *phone) {
    AppSendReceiveInfo *info = [AppSendReceiveInfo new];
    info.service = [AppServiceInfo new];
    info.service.open_city_name = open_city_name;
    info.service.service_name = service_name;
    info.customer = [AppCustomerInfo new];
    info.customer.freight_cust_name = freight_cust_name;
    info.customer.phone = phone;
    return info;
}

- (void)refreshSenderDetailLabel {
    BOOL hasSenderInfo = (self.detailData.shipper_name != nil);
    self.senderLabel.hidden = !hasSenderInfo;
    self.senderButton.selected = !hasSenderInfo;
    self.senderDetailLabel.width = hasSenderInfo ? self.contentImageView.left - self.senderDetailLabel.left : self.contentImageView.left - 2 * self.senderDetailLabel.left;
    if (self.detailData) {
        [self refreshSRInfo:NewAppSendReceiveInfo(_detailData.start_station_city_name, _detailData.start_station_service_name, _detailData.shipper_name, _detailData.shipper_phone) detailLabel:self.senderDetailLabel placeHolderString:@"发货人" textAlignment:NSTextAlignmentLeft];
    }
}

- (void)refreshReceiverDetailLabel {
    BOOL hasReceiver = (self.detailData.consignee_name != nil);
    self.receiverLabel.hidden = !hasReceiver;
    self.receiverButton.selected = !hasReceiver;
    
    CGFloat m_edge = self.contentView.width - self.receiverDetailLabel.right;
    self.receiverDetailLabel.width = hasReceiver ? self.receiverDetailLabel.right - self.contentImageView.right : self.receiverDetailLabel.right - self.contentImageView.right - m_edge;
    self.receiverDetailLabel.right = self.contentView.width - m_edge;
    if (self.detailData) {
        [self refreshSRInfo:NewAppSendReceiveInfo(_detailData.end_station_city_name, _detailData.end_station_service_name, _detailData.consignee_name, _detailData.consignee_phone) detailLabel:self.receiverDetailLabel placeHolderString:@"收货人" textAlignment:NSTextAlignmentRight];
    }
}

- (void)refreshSRInfo:(AppSendReceiveInfo *)info detailLabel:(UILabel *)label placeHolderString:(NSString *)holderSring textAlignment:(NSTextAlignment)alignment{
    if (info) {
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle1.lineSpacing = 0.0;
        paragraphStyle1.alignment = alignment;
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle2.lineSpacing = kEdge;
        paragraphStyle2.alignment = alignment;
        NSDictionary *dic1 = @{NSFontAttributeName:[AppPublic appFontOfSize:appLabelFontSize], NSForegroundColorAttributeName:baseTextColor, NSParagraphStyleAttributeName : paragraphStyle1};
        NSDictionary *dic2 = @{NSFontAttributeName:[AppPublic appFontOfSize:appLabelFontSizeSmall], NSForegroundColorAttributeName:baseTextColor, NSParagraphStyleAttributeName : paragraphStyle2};
        NSDictionary *dic3 = @{NSFontAttributeName:[AppPublic appFontOfSize:0], NSForegroundColorAttributeName:baseTextColor, NSParagraphStyleAttributeName : paragraphStyle2};
        
        NSMutableAttributedString *m_string = [NSMutableAttributedString new];
        [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@-%@\n", info.service.open_city_name, info.service.service_name] attributes:dic1]];
        [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:dic3]];
        [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", info.customer.freight_cust_name, info.customer.phone] attributes:dic2]];
        label.attributedText = m_string;
    }
    else {
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle1.lineSpacing = 0.0;
        paragraphStyle1.alignment = NSTextAlignmentCenter;
        NSDictionary *dic1 = @{NSFontAttributeName:[AppPublic appFontOfSize:16], NSForegroundColorAttributeName:secondaryTextColor, NSParagraphStyleAttributeName : paragraphStyle1};
        label.attributedText = [[NSAttributedString alloc] initWithString:holderSring attributes:dic1];
    }
}

#pragma mark - setter
- (void)setDetailData:(AppWayBillDetailInfo *)detailData {
    _detailData = detailData;
    
    self.titleView.textLabel.text = [NSString stringWithFormat:@"运单号/货号：%@/%@", detailData.waybill_number, detailData.goods_number];
    self.dateLabel.text = dateStringWithTimeString(detailData.operate_time);
    [self refreshSenderDetailLabel];
    [self refreshReceiverDetailLabel];
}
@end
