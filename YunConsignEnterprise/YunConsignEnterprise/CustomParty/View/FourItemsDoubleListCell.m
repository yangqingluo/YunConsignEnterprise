//
//  FourItemsDoubleListCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FourItemsDoubleListCell.h"

@interface FourItemsDoubleListCell ()

@end

@implementation FourItemsDoubleListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeMiddle, screen_width - 2 * kEdgeMiddle, kCellHeightHuge - kEdgeMiddle)];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.borderColor = baseSeparatorColor.CGColor;
        _baseView.layer.borderWidth = 1.0;
        [AppPublic roundCornerRadius:_baseView cornerRadius:kViewCornerRadius];
        [self.contentView addSubview:_baseView];
        
        UIView *lineView = NewSeparatorLine(CGRectMake(0, 0.5 * _baseView.height, _baseView.width, 1.0));
        lineView.centerY = 0.5 * _baseView.height;
        [_baseView addSubview:lineView];
        
        NSUInteger rows = 2;
        NSUInteger lines = 4;
        NSUInteger total = rows * lines;
        CGFloat separatorX = 0.6 * _baseView.width;
        CGFloat height = _baseView.height / rows;
        for (int i = 0; i < total; i++) {
            NSTextAlignment textAlignment = (i % 2 == 0) ? NSTextAlignmentLeft : NSTextAlignmentRight;
            CGFloat x = (i % lines < (lines / 2)) ? kEdge : separatorX + kEdge;
            CGFloat y = (i / lines) * height;
            CGFloat width = (i % lines < (lines / 2)) ? (separatorX - 2 * kEdge) : (_baseView.width - separatorX - 2 * kEdge);
            UILabel *label = NewLabel(CGRectMake(x, y, width, height), nil, nil, textAlignment);
            [_baseView addSubview:label];
            [self.labelArray addObject:label];
        }
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

#pragma mark - public
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightHuge;
}

- (void)addShowContents:(NSArray *)array {
    for (NSUInteger i = 0; i < array.count; i++) {
        id object = array[i];
        if ([object isKindOfClass:[NSString class]] && i < self.labelArray.count) {
            self.labelArray[i].text = object;
        }
    }
}

#pragma mark - getter
- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray new];
    }
    return _labelArray;
}

@end
