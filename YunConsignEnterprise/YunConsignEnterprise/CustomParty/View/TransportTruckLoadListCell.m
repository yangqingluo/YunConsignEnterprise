//
//  TransportTruckLoadListCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TransportTruckLoadListCell.h"
#import "PublicMutableLabelView.h"

@interface TransportTruckLoadListCell ()

@property (strong, nonatomic) UIView *baseView;

@end

@implementation TransportTruckLoadListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, self.contentView.height)];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_baseView];
        
        [AppPublic roundCornerRadius:_baseView cornerRadius:kViewCornerRadius];
        _baseView.layer.borderColor = baseSeparatorColor.CGColor;
        _baseView.layer.borderWidth = appSeparaterLineSize;
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath dataArray:(NSArray *)m_array {
    return kCellHeight * (m_array.count + 1);
}

#pragma mark - setter
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    for (UIView *subView in self.baseView.subviews) {
        [subView removeFromSuperview];
    }
    
    PublicMutableLabelView *titleView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, self.baseView.width, kCellHeight)];
    titleView.backgroundColor = CellHeaderLightBlueColor;
    [titleView updateDataSourceWithArray:@[@"装车门店", @"货量", @"票数/件数"]];
    [self.baseView addSubview:titleView];
    for (NSUInteger i = 0; i < dataArray.count; i++) {
        AppTransportTruckLoadInfo *item = dataArray[i];
        PublicMutableLabelView *labelView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, titleView.bottom + i * kCellHeight, self.baseView.width, kCellHeight)];
        [labelView updateDataSourceWithArray:[item showStringListForDetail]];
        [self.baseView addSubview:labelView];
        [self.baseView addSubview:NewSeparatorLine(CGRectMake(0, labelView.top, self.baseView.width, appSeparaterLineSize))];
    }
}

@end
