//
//  SearchCustomerCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SearchCustomerCell.h"

@interface SearchCustomerCell ()

@property (strong, nonatomic) UIView *baseView;

@end

@implementation SearchCustomerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeSmall, screen_width - 2 * kEdgeMiddle, kCellHeightHuge - 2 * kEdgeSmall)];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.borderColor = baseSeparatorColor.CGColor;
        _baseView.layer.borderWidth = 1.0;
        [AppPublic roundCornerRadius:_baseView cornerRadius:kViewCornerRadius];
        [self.contentView addSubview:_baseView];
        
        UIView *lineView = NewSeparatorLine(CGRectMake(0, 0.5 * _baseView.height, _baseView.width, 1.0));
        lineView.centerY = 0.5 * _baseView.height;
        [_baseView addSubview:lineView];
        
        _nameLabel = NewLabel(CGRectMake(kEdge, 0, _baseView.width - 2 * kEdge, 0.5 * _baseView.height), nil, nil, NSTextAlignmentLeft);
        [_baseView addSubview:_nameLabel];
        
        _phoneLabel = NewLabel(_nameLabel.frame, nil, nil, NSTextAlignmentRight);
        [_baseView addSubview:_phoneLabel];
        
        _goodsLabel = NewLabel(CGRectMake(kEdge, 0.5 * _baseView.height, _baseView.width - 2 * kEdge, 0.5 * _baseView.height), nil, nil, NSTextAlignmentLeft);
        [_baseView addSubview:_goodsLabel];
        
        _dateLabel = NewLabel(_goodsLabel.frame, nil, nil, NSTextAlignmentRight);
        [_baseView addSubview:_dateLabel];
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

#pragma mark - setter
- (void)setData:(AppCustomerInfo *)data {
    _data = data;
    
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", _data.freight_cust_name];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", _data.phone];
    self.goodsLabel.text = [NSString stringWithFormat:@"货物：%@", _data.last_deliver_goods];
    self.dateLabel.text = [NSString stringWithFormat:@"时间：%@", dateStringWithTimeString(_data.last_deliver_time)];
}

@end
