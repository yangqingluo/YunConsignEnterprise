//
//  QCSlideSwitchView.h
//  QCSliderTableView
//

#import <UIKit/UIKit.h>

@protocol QCSlideSwitchViewDelegate;
@interface QCSlideSwitchView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_rootScrollView;                  //主视图
    UIScrollView *_topScrollView;                   //顶部页签视图
    
    CGFloat _userContentOffsetX;
    BOOL _isLeftScroll;                             //是否左滑动
    BOOL _isRootScroll;                             //是否主视图滑动
    BOOL _isBuildUI;                                //是否建立了ui
    
    NSInteger _userSelectedChannelID;               //点击按钮选择名字ID

    UIColor *_tabItemNormalColor;                   //正常时tab文字颜色
    UIColor *_tabItemSelectedColor;                 //选中时tab文字颜色
    UIImage *_tabItemNormalBackgroundImage;         //正常时tab的背景
    UIImage *_tabItemSelectedBackgroundImage;       //选中时tab的背景
    NSMutableArray *_viewArray;                     //主视图的子视图数组
    
    UIButton *_rigthSideButton;                     //右侧按钮
    
    __weak id<QCSlideSwitchViewDelegate> _slideSwitchViewDelegate;
}

@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, assign) CGFloat userContentOffsetX;
@property (nonatomic, assign) NSInteger userSelectedChannelID;
@property (nonatomic, weak)  id<QCSlideSwitchViewDelegate> delegate;
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;

@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) UIButton *rigthSideButton;
@property (nonatomic, assign, readonly) NSUInteger selectedIndex;

/*!
 * @method 创建子视图UI
 */
- (void)buildUI;

//设置小红点视图的显示
- (void)showRedPoint:(BOOL)isShow withIndex:(NSUInteger)index;

//重载tab标题
- (void)reloadTabTitles;

@end

@protocol QCSlideSwitchViewDelegate <NSObject>

@required

- (CGFloat)widthOfTab:(NSUInteger)index;
- (NSString *)titleOfTab:(NSUInteger)index;

/*!
 * @method 顶部tab个数
 */
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view;

/*!
 * @method 每个tab所属的viewController
 */
- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number;

@optional

/*!
 * @method 滑动左边界时传递手势
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 滑动右边界时传递手势
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 点击tab
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number;

/*!
 * @method 取消选中点击tab
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view didunselectTab:(NSUInteger)number;

@end

