//
//  WayBillSRHeaderView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillSRHeaderView.h"
#import "SingleInputCell.h"
#import "PublicDatePickerView.h"

@interface WayBillSRHeaderView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView *contentImageView;

@end

@implementation WayBillSRHeaderView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, 160 + kCellHeightFilter + kEdge)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.date = [NSDate date];
        [self setupHeader];
        [self setupFooter];
        [self setupContent];
    }
    return self;
}

- (void)setupTitle {
    if (!_titleView) {
        self.height += kCellHeightFilter;
        _titleView = [[WaybillTitleView alloc] initWithFrame:CGRectMake(0, kEdge, self.width, kCellHeightFilter)];
        _titleView.textLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
        [self addSubview:_titleView];
        self.headerView.top = self.titleView.bottom;
        self.contentView.top = self.headerView.bottom;
        self.footerView.top = self.contentView.bottom;
    }
}

- (void)setupHeader {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kEdge, self.width, 40)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headerView];
    
    CGFloat leftSX = (4.0 / 17.0) * _headerView.width;
    CGFloat rightSX = (13.0 / 17.0) * _headerView.width;
    
    [_headerView addSubview:NewSeparatorLine(CGRectMake(0, 0, _headerView.width, appSeparaterLineSize))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(0, _headerView.height - appSeparaterLineSize, _headerView.width, appSeparaterLineSize))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(leftSX , 0, appSeparaterLineSize, _headerView.height))];
    [_headerView addSubview:NewSeparatorLine(CGRectMake(rightSX, 0, appSeparaterLineSize, _headerView.height))];
    
    _dateLabel = NewLabel(CGRectMake(leftSX, 0, rightSX - leftSX, _headerView.height), nil, nil, NSTextAlignmentCenter);
    [_headerView addSubview:_dateLabel];
    
    _senderLabel = NewLabel(CGRectMake(0, 0, leftSX - 0, _headerView.height), secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentCenter);
    [_headerView addSubview:_senderLabel];
    
    _receiverLabel = NewLabel(CGRectMake(rightSX, 0, _headerView.width - rightSX, _headerView.height), secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentCenter);
    [_headerView addSubview:_receiverLabel];
    
    self.dateLabel.text = stringFromDate(self.date, nil);
    self.senderLabel.text = @"发货人";
    self.senderLabel.hidden = YES;
    self.receiverLabel.text = @"收货人";
    self.receiverLabel.hidden = YES;
}

- (void)setupFooter {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kCellHeightFilter)];
    _footerView.bottom = self.height;
    _footerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_footerView];
    
    _footerTableView = [[UITableView alloc] initWithFrame:self.footerView.bounds];
    _footerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _footerTableView.delegate = self;
    _footerTableView.dataSource = self;
    _footerTableView.scrollEnabled = NO;
    [self.footerView addSubview:_footerTableView];
    
    [self.footerView addSubview:NewSeparatorLine(CGRectMake(0, self.footerView.height - appSeparaterLineSize, _footerView.width, appSeparaterLineSize))];
}

- (void)setupContent {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.width, self.footerView.top - self.headerView.bottom)];
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

- (void)refreshSenderDetailLabel {
    BOOL hasSenderInfo = (self.senderInfo != nil);
    self.senderLabel.hidden = !hasSenderInfo;
    self.senderButton.selected = !hasSenderInfo;
    self.senderDetailLabel.width = hasSenderInfo ? self.contentImageView.left - self.senderDetailLabel.left : self.contentImageView.left - 2 * self.senderDetailLabel.left;
    [self refreshSRInfo:self.senderInfo detailLabel:self.senderDetailLabel placeHolderString:@"发货人" textAlignment:NSTextAlignmentLeft];
}

- (void)refreshReceiverDetailLabel {
    BOOL hasReceiver = (self.receiverInfo != nil);
    self.receiverLabel.hidden = !hasReceiver;
    self.receiverButton.selected = !hasReceiver;
    
    CGFloat m_edge = self.contentView.width - self.receiverDetailLabel.right;
    self.receiverDetailLabel.width = hasReceiver ? self.receiverDetailLabel.right - self.contentImageView.right : self.receiverDetailLabel.right - self.contentImageView.right - m_edge;
    self.receiverDetailLabel.right = self.contentView.width - m_edge;
    [self refreshSRInfo:self.receiverInfo detailLabel:self.receiverDetailLabel placeHolderString:@"收货人" textAlignment:NSTextAlignmentRight];
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
        [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", notNilString(info.customer.freight_cust_name, @"无"), notNilString(info.customer.phone, @"无")] attributes:dic2]];
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

AppSendReceiveInfo *NewAppSendReceiveInfo(NSString *open_city_id, NSString *open_city_name, NSString *service_id, NSString *service_name, NSString *freight_cust_name, NSString *phone) {
    return NewAppSendReceiveInfoWithBankInfo(open_city_id, open_city_name, service_id, service_name, freight_cust_name, phone, nil, nil);
}

AppSendReceiveInfo *NewAppSendReceiveInfoWithBankInfo(NSString *open_city_id, NSString *open_city_name, NSString *service_id, NSString *service_name, NSString *freight_cust_name, NSString *phone, NSString *bank_name, NSString *bank_card_account) {
    AppSendReceiveInfo *info = [AppSendReceiveInfo new];
    info.service = [AppServiceInfo new];
    info.service.open_city_id = [open_city_id copy];
    info.service.open_city_name = [open_city_name copy];
    info.service.service_id = [service_id copy];
    info.service.service_name = [service_name copy];
    info.customer = [AppCustomerInfo new];
    info.customer.freight_cust_name = [freight_cust_name copy];
    info.customer.phone = [phone copy];
    info.customer.bank_name = [bank_name copy];
    info.customer.bank_card_account = [bank_card_account copy];
    return info;
}

AppSendReceiveInfo *NewAppSendReceiveInfoWithTownName(NSString *open_city_id, NSString *open_city_name, NSString *service_id, NSString *service_name, NSString *freight_cust_name, NSString *phone, NSString *real_station_city_name) {
    AppSendReceiveInfo *info = NewAppSendReceiveInfo(open_city_id, open_city_name, service_id, service_name, freight_cust_name, phone);
    info.town = [AppTownInfo new];
    info.town.town_name = [real_station_city_name copy];
    return info;
}

- (void)updateDataForWaybillDetailInfo:(AppWayBillDetailInfo *)detailData {
    [self updateDataForWaybillDetailInfo:detailData isReturn:NO];
}

- (void)updateDataForWaybillDetailInfo:(AppWayBillDetailInfo *)detailData isReturn:(BOOL)isReturn {
    self.titleView.textLabel.text = [NSString stringWithFormat:@"运单号/货号： %@/%@", detailData.waybill_number, detailData.goods_number];
    self.date = dateFromString(detailData.consignment_time, defaultDateFormat);
    if (isReturn) {
        self.receiverInfo = NewAppSendReceiveInfoWithBankInfo(detailData.start_station_city_id, detailData.start_station_city_name, detailData.start_station_service_id, detailData.start_station_service_name, detailData.shipper_name, detailData.shipper_phone, detailData.shipper_bank_name, detailData.shipper_bank_card_account);
        self.senderInfo = NewAppSendReceiveInfoWithTownName(detailData.end_station_city_id, detailData.end_station_city_name, detailData.end_station_service_id, detailData.end_station_service_name, detailData.consignee_name, detailData.consignee_phone, detailData.real_station_city_name);
    }
    else {
        self.senderInfo = NewAppSendReceiveInfoWithBankInfo(detailData.start_station_city_id, detailData.start_station_city_name, detailData.start_station_service_id, detailData.start_station_service_name, detailData.shipper_name, detailData.shipper_phone, detailData.shipper_bank_name, detailData.shipper_bank_card_account);
        self.receiverInfo = NewAppSendReceiveInfoWithTownName(detailData.end_station_city_id, detailData.end_station_city_name, detailData.end_station_service_id, detailData.end_station_service_name, detailData.consignee_name, detailData.consignee_phone, detailData.real_station_city_name);
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"date_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        cell.baseView.textField.enabled = NO;
        cell.baseView.lineView.hidden = YES;
    }
    cell.baseView.textLabel.text = @"托运时间";
    cell.baseView.textField.text = stringFromDate(self.date, nil);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    QKWEAKSELF;
    PublicDatePickerView *view = [[PublicDatePickerView alloc] initWithStyle:PublicDatePicker_Date andTitle:[NSString stringWithFormat:@"选择%@", @"托运时间"] callBlock:^(PublicDatePickerView *pickerView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            weakself.date = pickerView.datePicker.date;
        }
    }];
    view.datePicker.maximumDate = [NSDate date];
    id value = self.date;
    if (value) {
        view.datePicker.date = value;
    }
    [view show];
}

#pragma mark - setter
- (void)setSenderInfo:(AppSendReceiveInfo *)senderInfo {
    _senderInfo = senderInfo;
    [self refreshSenderDetailLabel];
}

- (void)setReceiverInfo:(AppSendReceiveInfo *)receiverInfo {
    _receiverInfo = receiverInfo;
    [self refreshReceiverDetailLabel];
}

- (void)setDate:(NSDate *)date {
    _date = date;
    self.dateLabel.text = stringFromDate(self.date, nil);
    [self.footerTableView reloadData];
}

@end
