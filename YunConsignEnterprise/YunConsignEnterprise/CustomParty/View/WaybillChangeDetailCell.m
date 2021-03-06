//
//  WaybillChangeDetailCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillChangeDetailCell.h"
#import "PublicMutableLabelView.h"

@interface WaybillChangeDetailCell ()

@property (strong, nonatomic) UIView *baseView;

@end

@implementation WaybillChangeDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeMiddle, screen_width - 2 * kEdgeMiddle, self.contentView.height - 2 * kEdgeMiddle)];
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath data:(AppWaybillChangeInfo *)m_data {
    return kEdgeMiddle * 2 + kCellHeight * (m_data.detail_list.count + 1);
}

#pragma mark - setter
- (void)setData:(AppWaybillChangeInfo *)data {
    _data = data;
    
    for (UIView *subView in self.baseView.subviews) {
        [subView removeFromSuperview];
    }
    
    PublicMutableLabelView *titleView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, self.baseView.width, kCellHeight)];
    titleView.backgroundColor = CellHeaderLightBlueColor;
    [titleView updateDataSourceWithArray:@[@"修改字段", @"修改前", @"修改后"]];
    [self.baseView addSubview:titleView];
    for (NSUInteger i = 0; i < data.detail_list.count; i++) {
        AppWaybillChangeDetailItemInfo *item = data.detail_list[i];
        PublicMutableLabelView *labelView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, titleView.bottom + i * kCellHeight, self.baseView.width, kCellHeight)];
        [labelView updateDataSourceWithArray:[item showStringListForChangeDetail]];
        [self.baseView addSubview:labelView];
        [self.baseView addSubview:NewSeparatorLine(CGRectMake(0, labelView.top, self.baseView.width, appSeparaterLineSize))];
    }
}
@end
