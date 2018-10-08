
#import "TSGameCenterToolbar.h"
#import "TSIconView.h"

//点击后扩大的大小
#define SCALESIZE 1

#define kIconViewMargin 5

//展开菜单view的标记
#define MENUBGTAG 1

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kPathOfFloatIcon ([self getFilePath:@"AppTacheSDK.bundle/images/tu_ic_dq_float" andType:@".png"])

typedef NS_ENUM (NSUInteger, LocationTag)
{
    kLocationTag_top = 1,
    kLocationTag_left,
    kLocationTag_bottom,
    kLocationTag_right
};

@interface TSGameCenterToolbar ()
{
    UIView *_bannerMenuV;//展开菜单的view
    TSIconView *_bannerIV;//浮标的imageview
    
    BOOL _bShowMenu;//是否在展开了菜单，展开时不允许移动浮标
    BOOL _bMoving;//是否在移动浮标
    
    float _w;
    float _h;
    
    float _nLogoWidth;//浮标的宽度
    float _nLogoHeight;//浮标的高度
    float _nMenuWidth;//菜单栏的宽度
    float _nMenuHeight;//菜单栏的高度＝＝浮标的宽度
    
    int _movenums;//展开浮标,6s移动事件过于灵敏，用作判断
    
    LocationTag _locationTag;
    
    UIInterfaceOrientation _lastOrientation;
}
@property (nonatomic, strong)NSTimer* timer;
@end

@implementation TSGameCenterToolbar

- (float)getLogoWidth
{
    return _nLogoWidth;
}

-(float)getLogoHeight
{
    return _nLogoHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initV:frame menuWidth:200];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame menuWidth:(float)nWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initV:frame menuWidth:nWidth];
    }
    return self;
}

- (void)dealloc
{
    [self removeObservers];
}

- (void)initV:(CGRect)frame menuWidth:(float)nWidth
{
    self.layer.cornerRadius = isIpad ? 37.5 : 30;
    self.backgroundColor = FJRGBColor(228, 227, 225);
    
    _bShowMenu = NO;
    _bMoving = NO;
    
    _locationTag = kLocationTag_bottom;
    _lastOrientation = -1;
    
    _locationTag = kLocationTag_bottom;
    _nLogoWidth = frame.size.width;
    _nMenuHeight = _nLogoHeight = frame.size.height;
    _nMenuWidth = nWidth;
    previousOrientation = -1;
    
    _bannerMenuV = [[UIView alloc] initWithFrame:CGRectMake(_nLogoWidth, 0, 0, 0)];
    [_bannerMenuV setClipsToBounds:YES];
    UIImageView *menuBgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _nMenuWidth, _nMenuHeight)];
    [menuBgIV setTag:MENUBGTAG];
    [_bannerMenuV addSubview:menuBgIV];
    [_bannerMenuV setHidden:YES];
    
    //account
    _accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountBtn setFrame:CGRectMake(5, 18, 36, 40)];
    
    [_accountBtn setTitle:@"账户" forState:UIControlStateNormal];
    [_accountBtn setTitleColor:FJBlackTitle forState:UIControlStateNormal];
    [_accountBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e004", 22, FJColorBlack)] forState:UIControlStateNormal];
    
    _accountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _accountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_accountBtn.imageView.frame.size.width, -_accountBtn.imageView.frame.size.height, 0);
    _accountBtn.imageEdgeInsets = UIEdgeInsetsMake(-_accountBtn.titleLabel.intrinsicContentSize.height, 0, 0, -_accountBtn.titleLabel.intrinsicContentSize.width);
    
    [_accountBtn addTarget:self action:@selector(accountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bannerMenuV addSubview:_accountBtn];
    
    _bannerIV = [[TSIconView alloc] initWithFrame:CGRectMake(kIconViewMargin, kIconViewMargin, _nLogoWidth-kIconViewMargin*2, _nLogoHeight-kIconViewMargin*2)];
    _bannerIV.layer.cornerRadius = _bannerIV.fj_width*0.5; //_nLogoWidth*0.4;
    [self setBannerImageView:YES];
    [self addSubview:_bannerMenuV];
    [self addSubview:_bannerIV];
    
    [self addObservers];
    [self deviceOrientationDidChange:nil];
    
    self.userInteractionEnabled = YES;
}

-(void)accountBtnClicked:(id)sender
{
    NSLog(@"GameCenterToolbar.m accountBtnClicked!");
    _bShowMenu = !_bShowMenu;
    
    [self showMenu:_bShowMenu time:0.3 complete:nil];
    
    if ([_delegate respondsToSelector:@selector(toolbar:didClickMenuAccount:)]) {
        [_delegate toolbar:self didClickMenuAccount:sender];
    }
}

- (void)setBannerImageView:(BOOL)bHide
{
    NSString *path = nil;
    if (bHide)
    {
        path = kPathOfFloatIcon;
    }else
    {
        path = kPathOfFloatIcon;
    }
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    [_bannerIV setImage:img];
}

-(void)showMenu
{
    //外部转屏调用
    [self showMenuExt:_bShowMenu time:0 complete:^
     {
         //[self shakeMenu:self];
     }];
}

- (void)showMenuExt:(BOOL)bShow time:(float)times complete:(void(^)(void))complete  //外部转屏调用修正
{
    self.userInteractionEnabled = NO;
    NSString *path = nil;
    
    if (bShow)
    {
        [_bannerMenuV setHidden:NO];
        if (self.frame.origin.x < 20)
        {
            path = kPathOfFloatIcon;
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _nMenuWidth + _nLogoWidth, _nMenuHeight)];
            [_bannerIV setFrame:CGRectMake(kIconViewMargin, kIconViewMargin, _nLogoWidth-kIconViewMargin*2, _nLogoHeight-kIconViewMargin*2)];
            [_bannerMenuV setFrame:CGRectMake(_nLogoWidth, 0, 0, _nMenuHeight)];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [_accountBtn setFrame:CGRectMake(5, 12, 36, 40)];
            } else {
                [_accountBtn setFrame:CGRectMake(5, 18, 36, 40)];
            }
            [UIView animateWithDuration:times animations:^
             {
                 [self->_bannerMenuV setFrame:CGRectMake(self->_nLogoWidth, 0, self->_nMenuWidth, self->_nMenuHeight)];
             } completion:^(BOOL finished)
             {
                 self.userInteractionEnabled = YES;
                 if (complete) {
                     complete();
                 }
             }];
        }else
        {
            path = kPathOfFloatIcon;
            [self setFrame:CGRectMake(self.frame.origin.x - _nMenuWidth, self.frame.origin.y, _nMenuWidth + _nLogoWidth, _nMenuHeight)];
            [_bannerIV setFrame:CGRectMake(_nMenuWidth - kIconViewMargin, kIconViewMargin, _nLogoWidth - 2*kIconViewMargin, _nLogoHeight-2* kIconViewMargin)];
            [_bannerMenuV setFrame:CGRectMake(_nMenuWidth, 0, 0, _nMenuHeight)];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [_accountBtn setFrame:CGRectMake(_nMenuWidth-5-36, 12, 36, 40)];
            } else {
                [_accountBtn setFrame:CGRectMake(_nMenuWidth-5-36, 18, 36, 40)];
            }
            [UIView animateWithDuration:times animations:^
             {
                 [self->_bannerMenuV setFrame:CGRectMake(0, 0, self->_nMenuWidth, self->_nMenuHeight)];
             } completion:^(BOOL finished)
             {
                 self.userInteractionEnabled = YES;
                 if (complete) {
                     complete();
                 }
             }];
        }
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        [_bannerIV setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
        
        CGPoint pt = [self ValidPoint:self.center];
        if (self.frame.origin.x < 20)
        {
            pt.x -= 36;
        }else
        {
            pt.x += 36;
        }
        [self setCenter:pt];
    }else
    {
        self.userInteractionEnabled = YES;
        
        CGPoint pt = [self ValidPoint:self.center];
        if (self.frame.origin.x < 20)
        {
            pt.x = -5;
        }
        [self setCenter:pt];
    }
    
    /*CGPoint pt = [self ValidPoint:self.center];
     
     [self setCenter:pt];*/
}

- (void)showMenu:(BOOL)bShow time:(float)times complete:(void(^)(void))complete
{
    _bShowMenu = bShow;
    self.userInteractionEnabled = NO;
    NSString *path = nil;
    
    if (bShow)
    {
        //点击浮标后全部显示浮标，不在屏幕之外
        CGPoint pt = [self ValidPoint:self.center];
        [self setCenter:pt];
        
        [_bannerMenuV setHidden:NO];
        if (self.frame.origin.x < 20) //显示在左边
        {
            path = kPathOfFloatIcon;
            [_bannerMenuV setFrame:CGRectMake(_nLogoWidth, 0, 0, _nMenuHeight)];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [_accountBtn setFrame:CGRectMake(5, 12, 36, 40)];
            } else {
                [_accountBtn setFrame:CGRectMake(5, 18, 36, 40)];
            }
            [UIView animateWithDuration:times animations:^
             {
                 [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self->_nMenuWidth + self->_nLogoWidth, self->_nMenuHeight)];
                 [self->_bannerIV setFrame:CGRectMake(kIconViewMargin, kIconViewMargin, self->_nLogoWidth - 2* kIconViewMargin, self->_nLogoHeight - 2* kIconViewMargin)];
                 [self->_bannerMenuV setFrame:CGRectMake(self->_nLogoWidth, 0, self->_nMenuWidth, self->_nMenuHeight)];
             } completion:^(BOOL finished)
             {
                 self.userInteractionEnabled = YES;
                 if (complete) {
                     complete();
                 }
             }];
        } else {
            path = kPathOfFloatIcon;
            [_bannerMenuV setFrame:CGRectMake(0, 0, 0, _nMenuHeight)];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [_accountBtn setFrame:CGRectMake(_nMenuWidth-5-36, 12, 36, 40)];
            } else {
                [_accountBtn setFrame:CGRectMake(_nMenuWidth-5-36, 18, 36, 40)];
            }
            
            [UIView animateWithDuration:times animations:^
             {
                 [self setFrame:CGRectMake(self.frame.origin.x - self->_nMenuWidth, self.frame.origin.y, self->_nMenuWidth + self->_nLogoWidth, self->_nMenuHeight)];
                 [self->_bannerIV setFrame:CGRectMake(self->_nMenuWidth + kIconViewMargin, kIconViewMargin, self->_nLogoWidth - 2*kIconViewMargin, self->_nLogoHeight - 2*kIconViewMargin)];
                 [self->_bannerMenuV setFrame:CGRectMake(0, 0, self->_nMenuWidth, self->_nMenuHeight)];
             } completion:^(BOOL finished)
             {
                 self.userInteractionEnabled = YES;
                 if (complete) {
                     complete();
                 }
             }];
        }
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        [_bannerIV setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
    } else {
        path = kPathOfFloatIcon;
        if (self.frame.origin.x < 20) //显示在左边
        {
            [UIView animateWithDuration:times animations:^ {
                 [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self->_nLogoWidth, self->_nMenuHeight)];
                [self->_bannerIV setFrame:CGRectMake(kIconViewMargin, kIconViewMargin, self->_nLogoWidth-kIconViewMargin*2, self->_nLogoHeight-kIconViewMargin*2)];
                 [self->_bannerMenuV setFrame:CGRectMake(self->_nLogoWidth, 0, 0, self->_nLogoHeight)];
             } completion:^(BOOL finished) {
                 UIImage *img = [UIImage imageWithContentsOfFile:path];
                 [self->_bannerIV setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
                 [self->_bannerMenuV setHidden:YES];
                 self.userInteractionEnabled = YES;
                 if (complete) {
                     complete();
                 }
             }];
        } else {
            [UIView animateWithDuration:times animations:^
             {
                 [self->_bannerMenuV setFrame:CGRectMake(0, 0, 0, self->_nMenuHeight)];
                 [self->_bannerIV setFrame:CGRectMake(kIconViewMargin, kIconViewMargin, self->_nLogoWidth-kIconViewMargin*2, self->_nLogoHeight-kIconViewMargin*2)];
                 [self setFrame:CGRectMake(self.frame.origin.x + self->_nMenuWidth, self.frame.origin.y, self->_nLogoWidth, self->_nMenuHeight)];
             } completion:^(BOOL finished) {
                 UIImage *img = [UIImage imageWithContentsOfFile:path];
                 [self->_bannerIV setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
                 [self->_bannerMenuV setHidden:YES];
                 self.userInteractionEnabled = YES;
                 if (complete) {
                     complete();
                 }
             }];
        }
    }
    
    /*CGPoint pt = [self ValidPoint:self.center];
     [self setCenter:pt];*/
}

- (void)computeOfLocation:(void(^)(void))complete
{
    
    float x = self.center.x;
    float y = self.center.y;
    CGPoint m = CGPointZero;
    m.x = x;
    m.y = y;
    
    //由于这里要展开菜单，所以只取两边就好--------------------------
    if (x < _w/2) {
        _locationTag = kLocationTag_left;
    } else {
        _locationTag = kLocationTag_right;
    }
    
    //---------------------------------------------------------
    
    switch (_locationTag) {
        case kLocationTag_top:
            m.y = 0 + _bannerIV.frame.size.width/2 + 20;
            break;
        case kLocationTag_left:
            //m.x = 0 + _bannerIV.frame.size.height/2;
            m.x = 0 - 5;
            break;
        case kLocationTag_bottom:
            m.y = _h - _bannerIV.frame.size.height/2;
            break;
        case kLocationTag_right:
            //m.x = _w - _bannerIV.frame.size.width/2;
            m.x = _w + 5;
            break;
    }
    
    //这个是在旋转是微调浮标出界时
    /*if (m.x > _w - _bannerIV.frame.size.width/2)
     m.x = _w - _bannerIV.frame.size.width/2;
     //    else if (m.x < _bannerIV.frame.size.width/2)
     //        m.x = _bannerIV.frame.size.width/2;
     if (m.y > _h - _bannerIV.frame.size.height/2)
     m.y = _h - _bannerIV.frame.size.height/2;
     //    else if (m.y < _bannerIV.frame.size.height/2)
     //        m.y = _bannerIV.frame.size.height/2;*/
    
    if (m.y > _h - _bannerIV.frame.size.height/2)
        m.y = _h - _bannerIV.frame.size.height/2;
    
    if (iPhoneX && ([self currentOrientation] == UIInterfaceOrientationLandscapeLeft || [self currentOrientation] == UIInterfaceOrientationLandscapeRight)) {
        if (m.x >= _w + 5) {
            m.x = _w + 5-34;
        } else {
            m.x = -5 + 34;
        }
    } else {
        if (m.x >= _w + 5) {
            m.x = _w + 5;
        } else {
            m.x = -5;
        }
    }
    
    
    [UIView animateWithDuration:0.1 animations:^ {
         [self setCenter:m];
     } completion:^(BOOL finished) {
         complete();
     }];
}

#pragma mark - action

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _bMoving = NO;
    _movenums = 0;
    
    if (!_bShowMenu) {
        [_bannerIV setFrame:CGRectMake(_bannerIV.frame.origin.x, _bannerIV.frame.origin.y, _bannerIV.frame.size.width + SCALESIZE, _bannerIV.frame.size.height + SCALESIZE)];
        NSString *path = kPathOfFloatIcon;
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        
        [_bannerIV setImage:img];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
    [self computeOfLocation:^ {
         [self setBannerImageView:YES];
         self->_bMoving = NO;
     }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_bShowMenu) {
        [_bannerIV setFrame:CGRectMake(_bannerIV.frame.origin.x, _bannerIV.frame.origin.y, _bannerIV.frame.size.width - SCALESIZE, _bannerIV.frame.size.height - SCALESIZE)];
    }
    
    if (!_bMoving) {
        UITouch *touch = [touches anyObject];
        CGPoint pt = [touch locationInView:self];
        if (CGRectContainsPoint(_bannerIV.frame, pt)) {
            _bShowMenu = !_bShowMenu;
            [self showMenu:_bShowMenu time:0.3 complete:^ {
                 //[self shakeMenu:self];
             }];
            return;
        } else {
            //展开状态点击任意地方都缩回去
            if ( _bShowMenu ) {
                _bShowMenu = !_bShowMenu;
                [self showMenu:_bShowMenu time:0.3 complete:^ {
                     //[self shakeMenu:self];
                 }];
            }
            return;
        }
    }
    
    [self computeOfLocation:^ {
         [self setBannerImageView:YES];
         self->_bMoving = NO;
     }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_bShowMenu)
    {
        return;
    }
    _movenums += 1;
    if ( _movenums <= 3 ) {
        return;
    }
    _bMoving = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint movedPT = [touch locationInView:[self superview]];
    
    CGPoint pt = [self ValidPoint:movedPT];
    
    [self setCenter:pt];
}

-(CGPoint) ValidPoint:(CGPoint) pt
{
    CGPoint ptRet;
    
    ptRet.x = MIN(MAX(pt.x, self.frame.size.width*0.5f), _w -self.frame.size.width*0.5f);
    ptRet.y = MIN(MAX(pt.y, self.frame.size.height*0.5f), _h-self.frame.size.height*0.5f);
    return ptRet;
}

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if(hitView != self && hitView != _accountBtn && hitView != _bannerMenuV && hitView != _bannerIV){
        
        if (_bShowMenu)
        {
            [self showMenu:false time:0.3 complete:^ {
                 //[self shakeMenu:self];
             }];
        }
        return nil;
    }
    return hitView;
}

#pragma mark - NSNotification

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [self currentOrientation];
    if (_lastOrientation == orientation) {
        return;
    }
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _w = rect.size.height;
        _h = rect.size.width;
    } else {
        _w = rect.size.width;
        _h = rect.size.height;
    }
    
    if ([[UIDevice currentDevice].systemVersion intValue] > 7){
        _w = rect.size.width;
        _h = rect.size.height;
    }
    
    _lastOrientation = orientation;
}

-(UIInterfaceOrientation)currentOrientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)setbannerIVpoint:(CGPoint)point
{
    CGPoint pt = [self ValidPoint:point];
    [self setCenter:pt];
}

- (NSString *)getFilePath:(NSString *)fileName andType:(NSString*)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    
    return path;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if ((self.fj_x == 0 || self.fj_x == kScreenWidth - self.fj_width) &&
        self.fj_width == self.fj_height) {
        [self.timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCount:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    } else {
        [self.timer invalidate];
    }
}

- (void)timerCount:(NSTimer *)timer
{
    static NSInteger count = 0;
    ++count;
    if (count >= 3) {
        count = 0;
        [self.timer invalidate];
        
        [UIView animateWithDuration:0.5 animations:^{
            if (self.fj_x == 0) {
                self.fj_centerX = 0;
            }
            if (self.fj_x == kScreenWidth - self.fj_width) {
                self.fj_centerX = kScreenWidth;
            }
        }];
    }
}

@end
