
#import <UIKit/UIKit.h>

@protocol TSGameCenterToolbarDelegate;

@interface TSGameCenterToolbar : UIView<UIAlertViewDelegate>
{
    UIButton *_accountBtn;
    UIInterfaceOrientation previousOrientation;
}

@property (nonatomic, weak)id<TSGameCenterToolbarDelegate> delegate;

/*
 *frame设置浮标位置及长宽
 *nWidth设置展出后增加的菜单宽带，可以动态计算传值
 */
- (instancetype)initWithFrame:(CGRect)frame menuWidth:(float)nWidth;

- (float)getLogoWidth;
- (float)getLogoHeight;

- (void)showMenu;
- (void)setbannerIVpoint:(CGPoint)point;//设置浮标的位置

@end

@protocol TSGameCenterToolbarDelegate <NSObject>

- (void)toolbar:(TSGameCenterToolbar*)toolbar didClickMenuAccount:(id)sender;

@end
