

#import <UIKit/UIKit.h>

@interface UDImageLabelButton : UIButton

@property (nonatomic, strong) UIImageView *upImageView;
@property (nonatomic, strong) UILabel *downLabel;

@property (nonatomic, strong) UIImageView *badgeImageView;//角标图片

@property (nonatomic, assign) BOOL autoAdjust;
@property (nonatomic, assign) double leftEdge;//图片和文本的左边距

- (void)startAnimation;

- (void)stopAnimation;

- (void)adjustTextAndImage;
@end
