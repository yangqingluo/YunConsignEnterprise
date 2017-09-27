//
//  TransportTrunkCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TransportTrunkCell.h"

#define height_TransportTrunkCell 200.0

@implementation TransportTrunkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeSmall, screen_width - 2 * kEdgeMiddle, height_TransportTrunkCell - 2 * kEdgeSmall)];
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
    
    _statusLabel = NewLabel(CGRectMake(_headerView.width - kEdgeMiddle - 200, 0, 200, _headerView.height), secondaryTextColor, nil, NSTextAlignmentRight);
    [_headerView addSubview:_statusLabel];
}

- (void)setupFooter {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.baseView.height - 32, self.baseView.width, 32)];
    [self.baseView addSubview:_footerView];
    [self refreshFooter];
}

- (void)refreshFooter {
    for (UIView *subView in self.footerView.subviews) {
        [subView removeFromSuperview];
    }
    
    [_footerView addSubview:NewSeparatorLine(CGRectMake(0, 0, _footerView.width, appSeparaterLineSize))];
    
    NSArray *m_array = @[@"装车详情", @"取消派车", @"发车"];
    if (self.indextag == 1) {
        m_array = @[@"装车详情"];
    }
    else if (self.indextag == 2) {
        if (self.data.cost_check.length) {
            m_array = @[@"装车详情"];
        }
        else {
            m_array = @[@"装车详情", @"发放运费"];
        }
    }
    
    NSUInteger count = m_array.count;
    CGFloat width = _footerView.width / 4;
    CGFloat x = _footerView.width - width * count;
    for (NSUInteger i = 0; i < 4; i++) {
        if (i < count) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, _footerView.height)];
            btn.left = x + i * width;
            [btn setTitle:m_array[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
            [_footerView addSubview:btn];
            
            if (btn.left != 0.0) {
                [_footerView addSubview:NewSeparatorLine(CGRectMake(btn.left, 0, appSeparaterLineSize, _footerView.height))];
            }
        }
    }
}

- (void)setupBody {
    _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.baseView.width, self.footerView.top - self.headerView.bottom)];
    [self.baseView addSubview:_bodyView];
    
    _truckLabel = NewLabel(CGRectMake(kEdgeMiddle, kEdgeBig, _bodyView.width - 2 * kEdgeMiddle, 24), nil, nil, NSTextAlignmentLeft);
//    _truckLabel.adjustsFontSizeToFitWidth = YES;
    [_bodyView addSubview:_truckLabel];
    
    _costRegisterLabel = NewLabel(CGRectMake(_truckLabel.left, _truckLabel.bottom + kEdgeMiddle, 100, _truckLabel.height), nil, nil, NSTextAlignmentLeft);
    [_bodyView addSubview:_costRegisterLabel];
    
    _costCheckLabel = NewLabel(_costRegisterLabel.frame, nil, nil, NSTextAlignmentLeft);
    [_bodyView addSubview:_costCheckLabel];
    
    _loadQuantityLabel = NewLabel(CGRectMake(_truckLabel.left, _costRegisterLabel.bottom + kEdgeMiddle, _truckLabel.width, _truckLabel.height), nil, nil, NSTextAlignmentLeft);
    [_bodyView addSubview:_loadQuantityLabel];
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
    return height_TransportTrunkCell;
}

#pragma mark - setter
- (void)setData:(AppTransportTrunkInfo *)data {
    _data = data;
    
    self.titleLabel.text = data.route;
    self.statusLabel.text = dateStringWithTimeString(data.operate_time);
    [AppPublic adjustLabelWidth:self.statusLabel];
    self.statusLabel.right = self.headerView.right - kEdgeMiddle;
    
    self.truckLabel.text = [NSString stringWithFormat:@"登记车辆：%@", data.truck_info];
    self.costRegisterLabel.text = [NSString stringWithFormat:@"登记运费：%@", data.cost_register];
    [AppPublic adjustLabelWidth:self.costRegisterLabel];
    if (data.cost_check.length) {
        self.costCheckLabel.hidden = NO;
        self.costCheckLabel.text = [NSString stringWithFormat:@"发放运费：%@", data.cost_check];
        [AppPublic adjustLabelWidth:self.costCheckLabel];
        self.costCheckLabel.left = self.costRegisterLabel.right + kEdgeBig;
    }
    else {
        self.costCheckLabel.hidden = YES;
    }
    
    self.loadQuantityLabel.text = [NSString stringWithFormat:@"装车货量：%@", data.load_quantity];
    [self refreshFooter];
}

@end
