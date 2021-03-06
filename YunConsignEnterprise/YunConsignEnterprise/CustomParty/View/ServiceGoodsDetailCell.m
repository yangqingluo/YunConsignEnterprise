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
        _baseView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeight)];
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath data:(AppServiceGoodsDetailInfo *)data {
    CGFloat goods_name_height = [AppPublic textSizeWithString:data.goods_name font:[PublicMutableLabelView new].mutableLabelFont constantWidth:0.2 * screen_width].height + kEdgeMiddle;
    CGFloat consignee_name_height = [AppPublic textSizeWithString:data.consignee_name font:[PublicMutableLabelView new].mutableLabelFont constantWidth:0.2 * screen_width].height + kEdgeMiddle;
    return MAX(kCellHeight, MAX(goods_name_height, consignee_name_height));
}

#pragma mark - setter
- (void)setData:(AppServiceGoodsDetailInfo *)data {
    _data = data;
    self.baseView.height = [[self class] tableView:nil heightForRowAtIndexPath:nil data:data];
    [self.baseView updateDataSourceWithArray:@[data.goods_number, data.goods_name, notShowFooterZeroString(data.total_amount, @"0"), data.consignee_name]];
//    if (self.baseView.showViews.count == 4) {
//        UILabel *label = self.baseView.showViews[3];
//        label.textColor = MainColor;
//    }
}

@end
