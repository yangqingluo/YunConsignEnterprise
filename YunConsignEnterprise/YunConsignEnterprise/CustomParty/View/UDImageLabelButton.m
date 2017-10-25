

#import "UDImageLabelButton.h"

#define edge_scale 0.7

@implementation UDImageLabelButton

- (void)dealloc{
    [self.downLabel removeObserver:self forKeyPath:@"text"];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.leftEdge = kEdge;
        
        self.upImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, frame.size.width - 15, edge_scale * frame.size.height)];
        [self addSubview:self.upImageView];
        
        self.downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, edge_scale * frame.size.height, frame.size.width, (1 - edge_scale) * frame.size.height)];
        self.downLabel.textColor = [UIColor whiteColor];
        self.downLabel.font = [UIFont systemFontOfSize:12.0];
        self.downLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.downLabel];
        
        [self.downLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    
    return self;
}

- (void)startAnimation{
    self.enabled = NO;
    
    CABasicAnimation * transformRoate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    transformRoate.byValue = [NSNumber numberWithDouble:(2 * M_PI)];
    transformRoate.duration = 1;
    transformRoate.repeatCount = MAXFLOAT;
    [self.upImageView.layer addAnimation:transformRoate forKey:@"rotationAnimation"];
}

- (void)stopAnimation{
    self.enabled = YES;
    
    [self.upImageView.layer removeAllAnimations];
}

- (void)adjustTextAndImage{
    CGSize labelSize = [AppPublic textSizeWithString:self.downLabel.text font:self.downLabel.font constantHeight:self.downLabel.height];
    self.downLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    self.downLabel.center = CGPointMake(0.5 * self.width - 0.5 * self.upImageView.width, 0.5 * self.height);
    
    self.upImageView.center = CGPointMake(self.downLabel.right + self.leftEdge + 0.5 * self.upImageView.width, 0.5 * self.height);
}

#pragma kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"text"]){
        if (self.autoAdjust) {
            [self adjustTextAndImage];
        }
    }
}

#pragma setter
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    self.downLabel.highlighted = selected;
    self.upImageView.highlighted = selected;
}

@end
