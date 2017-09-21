//
//  GoodsSummaryCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "GoodsSummaryCell.h"

@implementation GoodsSummaryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeMiddle, screen_width - 2 * kEdgeMiddle, kCellHeight)];
        _baseView.backgroundColor = lightWhiteColor;
        _baseView.layer.borderColor = baseSeparatorColor.CGColor;
        _baseView.layer.borderWidth = 1.0;
        [AppPublic roundCornerRadius:_baseView cornerRadius:kViewCornerRadius];
        [self.contentView addSubview:_baseView];
        
        NSUInteger rows = 1;
        NSUInteger lines = 4;
        NSUInteger total = rows * lines;
        CGFloat separatorX = 0.6 * _baseView.width;
        CGFloat height = _baseView.height / rows;
        for (int i = 0; i < total; i++) {
            NSTextAlignment textAlignment = (i % 2 == 0) ? NSTextAlignmentLeft : NSTextAlignmentRight;
            CGFloat x = (i % lines < (lines / 2)) ? kEdge : separatorX + kEdge;
            CGFloat y = (i / lines) * height;
            CGFloat width = (i % lines < (lines / 2)) ? (separatorX - 2 * kEdge) : (_baseView.width - separatorX - 2 * kEdge);
            
            if (i == 1) {
                IndexPathTextField *textField = [[IndexPathTextField alloc] initWithFrame:CGRectMake(x + 60, y + kEdgeSmall, width - 60, height - 2 * kEdgeSmall)];
                textField.textColor = baseTextColor;
                textField.font = [AppPublic appFontOfSize:appLabelFontSize];
                textField.textAlignment = textAlignment;
                textField.backgroundColor = [UIColor whiteColor];
                textField.layer.borderColor = baseSeparatorColor.CGColor;
                textField.layer.borderWidth = appSeparaterLineSize;
                [AppPublic roundCornerRadius:textField cornerRadius:4];
                textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kEdge, 0)];
                textField.leftViewMode = UITextFieldViewModeAlways;
                textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kEdge, 0)];
                textField.rightViewMode = UITextFieldViewModeAlways;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                
                [_baseView addSubview:textField];
                [self.showArray addObject:textField];
            }
            else {
                UILabel *label = NewLabel(CGRectMake(x, y, width, height), nil, nil, textAlignment);
                [_baseView addSubview:label];
                [self.showArray addObject:label];
            }
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
    return kCellHeight + 2 * kEdgeMiddle;
}

- (void)addShowContents:(NSArray *)array {
    for (NSUInteger i = 0; i < array.count; i++) {
        id object = array[i];
        if ([object isKindOfClass:[NSString class]] && i < self.showArray.count) {
            [self.showArray[i] setValue:object forKey:@"text"];
        }
    }
}

#pragma mark - getter
- (NSMutableArray *)showArray {
    if (!_showArray) {
        _showArray = [NSMutableArray new];
    }
    return _showArray;
}

@end
