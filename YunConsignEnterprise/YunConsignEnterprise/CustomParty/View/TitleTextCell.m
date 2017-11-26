//
//  TitleTextCell.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/6/14.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "TitleTextCell.h"

@implementation TitleTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdge, screen_width - 3 * kEdgeMiddle, kCellHeight - 2 * kEdge)];
        self.titleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title{
    return [TitleTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:title titleFont:[UIFont systemFontOfSize:appLabelFontSize]];
}
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title titleFont:(UIFont *)titleFont{
    CGFloat width = screen_width - 3 * kEdgeMiddle;
    CGFloat height = kEdge + [AppPublic textSizeWithString:title font:titleFont constantWidth:width].height + kEdge;
    
    return MAX(kCellHeight, height);
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
    
    CGFloat height = [AppPublic textSizeWithString:title font:self.titleLabel.font constantWidth:self.titleLabel.width].height;
    self.titleLabel.height = MAX(kCellHeight - 2 * kEdge, height);
}

@end
