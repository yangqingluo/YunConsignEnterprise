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
}

- (void)setupFooter {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.baseView.height - 32, self.baseView.width, 32)];
    [self.baseView addSubview:_footerView];
    
    [_footerView addSubview:NewSeparatorLine(CGRectMake(0, 0, _footerView.width, appSeparaterLineSize))];
}

- (void)setupBody {
    _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.baseView.width, self.footerView.top - self.headerView.bottom)];
    [self.baseView addSubview:_bodyView];
    
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
}

@end
