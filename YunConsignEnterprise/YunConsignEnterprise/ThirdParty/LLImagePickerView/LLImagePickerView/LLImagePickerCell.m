//
//  LLImagePickerCell.m
//  LLImagePickerDemo
//
//  Created by liushaohua on 2017/6/1.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLImagePickerCell.h"
#import "LLImagePickerConst.h"

@implementation LLImagePickerCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    _icon = [[UIImageView alloc] init];
    _icon.clipsToBounds = YES;
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_icon];
    
    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"LLImagePicker.bundle/deleteButton" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LLImagePicker.bundle/ShowVideo" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
    [self.contentView addSubview:_videoImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat m_edge = self.showDelete ? 0.5 * LLPickerDeleteButtonWidth : LLPickerRatio * 4;
    _icon.frame = CGRectMake(m_edge, m_edge, self.bounds.size.width - 2 * m_edge, self.bounds.size.width - 2 * m_edge);
    _deleteButton.frame = CGRectMake(self.bounds.size.width - 2 * m_edge, 0, 2 * m_edge, 2 * m_edge);
    _videoImageView.frame = CGRectMake(self.bounds.size.width/4, self.bounds.size.width/4, self.bounds.size.width/2, self.bounds.size.width/2);
}
- (void)clickDeleteButton {

    !_LLClickDeleteButton ?  : _LLClickDeleteButton(self.cellIndexPath);
}

@end
