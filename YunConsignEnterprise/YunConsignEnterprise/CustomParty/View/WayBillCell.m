//
//  WayBillCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillCell.h"

#define height_WayBillCell 200.0

@implementation WayBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeSmall, screen_width - 2 * kEdgeMiddle, height_WayBillCell - 2 * kEdgeSmall)];
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
    
    _titleLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, 0.5 * _headerView.width, _headerView.height), nil, nil, NSTextAlignmentLeft);
    [_headerView addSubview:_titleLabel];
    
    _urgentLabel = NewLabel(CGRectMake(_titleLabel.right + kEdgeMiddle, 0, 30, _headerView.height), RGBA(0xc5, 0x2c, 0x2c, 1.0), [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _urgentLabel.text = @"[急]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [_headerView addSubview:_urgentLabel];
    
    _statusLabel = NewLabel(CGRectMake(_headerView.width - kEdgeMiddle - 120, 0, 120, _headerView.height), secondaryTextColor, nil, NSTextAlignmentRight);
    [_headerView addSubview:_statusLabel];
    
    _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [AppPublic roundCornerRadius:_statusImageView];
    _statusImageView.backgroundColor = [UIColor lightGrayColor];
    _statusImageView.centerY = _statusLabel.centerY;
    _statusImageView.right = _statusLabel.left + kEdge;
    [_headerView addSubview:_statusImageView];
}

- (void)setupFooter {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.baseView.height - 32, self.baseView.width, 32)];
    [self.baseView addSubview:_footerView];
    
    [_footerView addSubview:NewSeparatorLine(CGRectMake(0, 0, _footerView.width, appSeparaterLineSize))];
    
    NSArray *m_array = @[@"作废", @"修改", @"打印", @"物流"];
    NSUInteger count = m_array.count;
    CGFloat width = _footerView.width / count;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, _footerView.height)];
        btn.left = i * width;
        [btn setTitle:m_array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [_footerView addSubview:btn];
        [_footerView addSubview:NewSeparatorLine(CGRectMake(btn.right, 0, appSeparaterLineSize, _footerView.height))];
    }
}

- (void)setupBody {
    _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.baseView.width, self.footerView.top - self.headerView.bottom)];
    [self.baseView addSubview:_bodyView];
    
    _goodsLabel = NewLabel(CGRectMake(kEdgeMiddle, kEdgeBig, _bodyView.width - 2 * kEdgeMiddle, 24), nil, nil, NSTextAlignmentLeft);
    [_bodyView addSubview:_goodsLabel];
    
    _customerLabel = NewLabel(CGRectMake(_goodsLabel.left, _goodsLabel.bottom + kEdgeMiddle, _goodsLabel.width, _goodsLabel.height), nil, nil, NSTextAlignmentLeft);
    [_bodyView addSubview:_customerLabel];
    
    _payOnDeliverLabel = NewLabel(CGRectMake(_customerLabel.left, _customerLabel.bottom + kEdgeMiddle, 100, _goodsLabel.height), nil, nil, NSTextAlignmentLeft);
    [_bodyView addSubview:_payOnDeliverLabel];
    
    _payNowLabel = NewLabel(_payOnDeliverLabel.frame, nil, nil, NSTextAlignmentLeft);
    [_bodyView addSubview:_payNowLabel];
    
    _payOnReceiptLabel = NewLabel(_payOnDeliverLabel.frame, nil, nil, NSTextAlignmentLeft);
    [_bodyView addSubview:_payOnReceiptLabel];
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
    return height_WayBillCell;
}

#pragma mark - setter
- (void)setData:(AppWayBillInfo *)data {
    _data = data;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@：%@", _data.route, _data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    if ([_data.is_urgent boolValue]) {
        self.urgentLabel.hidden = NO;
        self.urgentLabel.left = self.titleLabel.right + kEdgeMiddle;
    }
    else {
        self.urgentLabel.hidden = YES;
    }
    
    self.statusLabel.text = [_data statusStringForState];
    [AppPublic adjustLabelWidth:self.statusLabel];
    self.statusLabel.right = self.headerView.right - kEdgeMiddle;
    self.statusImageView.right = self.statusLabel.left - kEdge;
    self.statusImageView.backgroundColor = [_data statusColorForState];
    
    self.goodsLabel.text = [NSString stringWithFormat:@"货物：%@", _data.goods];
    self.customerLabel.text = [NSString stringWithFormat:@"客户：%@", _data.cust];
    self.payOnDeliverLabel.text = [NSString stringWithFormat:@"提付：%@", _data.pay_on_delivery_amount];
    [AppPublic adjustLabelWidth:self.payOnDeliverLabel];
    
    self.payNowLabel.text = [NSString stringWithFormat:@"现付：%@", _data.pay_now_amount];
    [AppPublic adjustLabelWidth:self.payNowLabel];
    self.payNowLabel.left = self.payOnDeliverLabel.right + kEdgeBig;
    
    self.payOnReceiptLabel.text = [NSString stringWithFormat:@"回单付：%@", _data.pay_on_receipt_amount];
    [AppPublic adjustLabelWidth:self.payOnReceiptLabel];
    self.payOnReceiptLabel.left = self.payNowLabel.right + kEdgeBig;
}

@end
