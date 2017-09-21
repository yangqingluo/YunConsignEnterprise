//
//  SingleInputCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SingleInputCell.h"

#define SingleInputATypeObserverKey @"accessoryType"

@implementation SingleInputCell

- (void)dealloc {
    [self removeObserver:self forKeyPath:SingleInputATypeObserverKey];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _inputView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeMiddle, screen_width - 2 * kEdgeMiddle, self.contentView.height - 2 * kEdgeMiddle)];
        _inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_inputView];
        
        [self addObserver:self forKeyPath:SingleInputATypeObserverKey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
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

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:SingleInputATypeObserverKey]){
        if (self.accessoryType == UITableViewCellAccessoryNone) {
            self.inputView.width = screen_width - 2 * kEdgeMiddle;
        }
        else {
            self.inputView.width = screen_width - kEdgeMiddle - kEdgeHuge;
        }
    }
}
@end
