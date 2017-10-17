//
//  ServiceGoodsDetailCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "ServiceGoodsDetailCell.h"
#import "PublicMutableLabelView.h"

@interface ServiceGoodsDetailCell ()

@property (strong, nonatomic) PublicMutableLabelView *baseView;

@end

@implementation ServiceGoodsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _baseView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightMiddle)];
        _baseView.showVerticalSeparator = NO;
        [_baseView updateEdgeSourceWithArray:@[@0.4, @0.2, @0.2, @0.2]];
        [self.contentView addSubview:_baseView];
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
    return kCellHeightMiddle;
}

#pragma mark - setter
- (void)setData:(AppServiceGoodsDetailInfo *)data {
    _data = data;
    [self.baseView updateDataSourceWithArray:@[data.goods_number, data.goods_name, data.total_amount, [data.is_load intValue] > 0 ? @"√" : @""]];
    if (self.baseView.showViews.count == 4) {
        UIButton *btn = self.baseView.showViews[3];
        [btn setTitleColor:MainColor forState:UIControlStateNormal];
    }
}

@end
