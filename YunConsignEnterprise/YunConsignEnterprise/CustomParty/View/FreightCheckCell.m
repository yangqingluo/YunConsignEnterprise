//
//  FreightCheckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/31.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightCheckCell.h"

@interface FreightCheckCell ()

@property (strong, nonatomic) PublicMutableLabelView *baseView;

@end

@implementation FreightCheckCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeight)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_baseView];
        
        [self.baseView updateEdgeSourceWithArray:[[self class] edgeSourceArray]];
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

+ (NSArray *)edgeSourceArray {
    return @[@0.1, @0.3, @0.2, @0.2, @0.2];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

#pragma mark - setter
- (void)setData:(AppCheckFreightWayBillInfo *)data {
    _data = data;
    
    NSMutableArray *m_array = [NSMutableArray new];
    [m_array addObject:[NSString stringWithFormat:@"%d", (int)self.indexPath.row + 1]];
    [m_array addObject:data.goods_number];
    [m_array addObject:data.pay_now_amount];
    [m_array addObject:data.pay_on_delivery_amount];
    [m_array addObject:data.pay_on_receipt_amount];
    [self.baseView updateDataSourceWithArray:m_array];
}
@end
