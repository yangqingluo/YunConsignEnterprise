//
//  PublicHeaderBodyCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyCell.h"

#import "UIResponder+Router.h"

@interface PublicHeaderBodyCell ()

@end

@implementation PublicHeaderBodyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [self initWithHeaderStyle:PublicHeaderCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithHeaderStyle:(PublicHeaderCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headerStyle = style;
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeSmall, kEdgeSmall, screen_width - 2 * kEdgeSmall, self.contentView.height - 2 * kEdgeSmall)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_baseView];
        
        [AppPublic roundCornerRadius:_baseView cornerRadius:kViewCornerRadius];
        _baseView.layer.borderColor = baseSeparatorColor.CGColor;
        _baseView.layer.borderWidth = appSeparaterLineSize;
        
        self.baseView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [self setupHeader];
        [self setupBody];
    }
    
    return self;
}

- (void)setupHeader {
    if (self.headerStyle == PublicHeaderCellStyleSelection) {
        _headerSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kCellHeightSmall, kCellHeightSmall)];
        _headerSelectBtn.backgroundColor = [UIColor whiteColor];
        [_headerSelectBtn setImage:[UIImage imageNamed:@"list_icon_checkbox_normal"] forState:UIControlStateNormal];
        [_headerSelectBtn setImage:[UIImage imageNamed:@"list_icon_checkbox_selcted"] forState:UIControlStateSelected];
        [_headerSelectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:_headerSelectBtn];
        [self.baseView addSubview:NewSeparatorLine(CGRectMake(self.headerSelectBtn.right - appSeparaterLineSize, 0, appSeparaterLineSize, self.headerSelectBtn.height))];
    }
    CGFloat x_header = self.headerSelectBtn ? self.headerSelectBtn.right : 0;
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(x_header, 0, self.baseView.width - x_header, kCellHeightSmall)];
    _headerView.backgroundColor = CellHeaderLightBlueColor;
    [self.baseView addSubview:_headerView];
    
    [self.baseView addSubview:NewSeparatorLine(CGRectMake(0, _headerView.height - appSeparaterLineSize, self.baseView.width, appSeparaterLineSize))];
    
    _titleLabel = NewLabel(CGRectMake(kEdge, 0, 0.5 * _headerView.width, _headerView.height), nil, nil, NSTextAlignmentLeft);
    [_headerView addSubview:_titleLabel];
    
    _statusLabel = NewLabel(CGRectMake(_headerView.width - kEdge - 200, 0, 200, _headerView.height), secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentRight);
    [_headerView addSubview:_statusLabel];
}

- (void)setupBody {
    _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.baseView.width, [[self class] tableView:nil heightForRowAtIndexPath:nil] - self.headerView.bottom)];
    [self.baseView addSubview:_bodyView];
    
    _bodyLabel1 = NewLabel(CGRectMake(kEdge, kEdgeMiddle, _bodyView.width - 2 * kEdge, 24), nil, nil, NSTextAlignmentLeft);
    //    _bodyLabel1.adjustsFontSizeToFitWidth = YES;
    [_bodyView addSubview:_bodyLabel1];
    
    _bodyLabel2 = NewLabel(_bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel2.top = _bodyLabel1.bottom + kEdge;
    [_bodyView addSubview:_bodyLabel2];
    
    _bodyLabel3 = NewLabel(_bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel3.top = _bodyLabel2.bottom + kEdge;
    [_bodyView addSubview:_bodyLabel3];
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
    return [PublicHeaderBodyCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:3];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath bodyLabelLines:(NSUInteger)lines {
    return 2 * kEdgeSmall + kCellHeightSmall + [PublicHeaderBodyCell heightForBodyWithLabelLines:lines];
}

+ (CGFloat)heightForBodyWithLabelLines:(NSUInteger)lines {
    NSUInteger m_lines = MAX(1, lines);
    return 2 * kEdgeMiddle + m_lines * 24.0 + (m_lines - 1) * kEdge;
}

- (void)selectBtnAction:(UIButton *)button {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"tag" : @(button.tag)}];
    if (self.indexPath) {
        [m_dic setObject:self.indexPath forKey:@"indexPath"];
    }
    [self routerEventWithName:Event_PublicHeaderCellSelectButtonClicked userInfo:[NSDictionary dictionaryWithDictionary:m_dic]];
}

#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
}

@end
