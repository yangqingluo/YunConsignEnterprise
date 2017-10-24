//
//  EndServiceCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "EndServiceCell.h"

@interface EndServiceCell ()

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIView *leftLineView;
@property (strong, nonatomic) UIView *rightLineView;


@end

@implementation EndServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeMiddle, self.contentView.width - 2 * kEdgeMiddle, self.contentView.height - 2 * kEdgeMiddle)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_baseView];
        
        [AppPublic roundCornerRadius:_baseView cornerRadius:kViewCornerRadius];
        _baseView.layer.borderColor = baseSeparatorColor.CGColor;
        _baseView.layer.borderWidth = appSeparaterLineSize;
        
        CGFloat radius = _baseView.height;
        _indexLabel = NewLabel(CGRectMake(0, 0, radius, radius), secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSize], NSTextAlignmentCenter);
        [_baseView addSubview:_indexLabel];
        
        _removeBtn = NewRightButton([UIImage imageNamed:@"list_icon_delete"], nil);
        _removeBtn.imageEdgeInsets = UIEdgeInsetsZero;
        _removeBtn.frame = CGRectMake(_baseView.width - radius, 0, radius, radius);
        [_baseView addSubview:_removeBtn];
        
        _detailLabel = NewLabel(CGRectMake(_indexLabel.right + kEdgeMiddle, 0, _removeBtn.left - _indexLabel.right - 2 * kEdgeMiddle, radius), _indexLabel.textColor, _indexLabel.font, NSTextAlignmentLeft);
        _detailLabel.numberOfLines = 0;
        _detailLabel.adjustsFontSizeToFitWidth = YES;
        [_baseView addSubview:_detailLabel];
        
        _leftLineView = NewSeparatorLine(CGRectMake(self.indexLabel.right, 0, appSeparaterLineSize, self.baseView.height));
        [_baseView addSubview:_leftLineView];
        _rightLineView = NewSeparatorLine(CGRectMake(self.removeBtn.left, 0, appSeparaterLineSize, self.baseView.height));
        [_baseView addSubview:_rightLineView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.baseView.frame = CGRectMake(kEdgeMiddle, kEdgeMiddle, self.contentView.width - 2 * kEdgeMiddle, self.contentView.height - 2 * kEdgeMiddle);
    CGFloat radius = _baseView.height;
    self.indexLabel.frame = CGRectMake(0, 0, radius, radius);
    self.removeBtn.frame = CGRectMake(_baseView.width - radius, 0, radius, radius);
    self.detailLabel.frame = CGRectMake(_indexLabel.right + kEdgeMiddle, 0, _removeBtn.left - _indexLabel.right - 2 * kEdgeMiddle, radius);
    self.leftLineView.frame = CGRectMake(self.indexLabel.right, 0, appSeparaterLineSize, self.baseView.height);
    self.rightLineView.frame = CGRectMake(self.removeBtn.left, 0, appSeparaterLineSize, self.baseView.height);
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

@end
