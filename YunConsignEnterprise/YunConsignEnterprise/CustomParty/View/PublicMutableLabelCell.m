//
//  PublicMutableLabelCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicMutableLabelCell.h"

@implementation PublicMutableLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier showWidth:screen_width showValueArray:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showWidth:(CGFloat)width showValueArray:(NSArray *)valArray {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _valArray = [valArray copy];
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, width, kCellHeight)];
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


@end
