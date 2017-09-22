//
//  WayBillTitleCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillTitleCell.h"

@implementation WayBillTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *leftColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kEdgeSmall, self.contentView.height)];
        leftColorView.backgroundColor = MainColor;
        leftColorView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:leftColorView];
        
        UIView *lineView = NewSeparatorLine(CGRectMake(0, self.height - appSeparaterLineSize, screen_width, appSeparaterLineSize));
        lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:lineView];
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:appLabelFontSizeMiddle];
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

@end
