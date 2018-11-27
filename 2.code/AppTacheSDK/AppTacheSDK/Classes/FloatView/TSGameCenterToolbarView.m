//
//  TSGameCenterToolbarView.m
//  AppTache
//
//  Created by niko on 18-7-18.
//  Copyright (c) 2018年 niko. All rights reserved.
//

#import "TSGameCenterToolbarView.h"
#import "TSGameCenterToolbar.h"

@interface TSGameCenterToolbarView () <TSGameCenterToolbarDelegate>
{
    TSGameCenterToolbar *_toolBar;
    UIDeviceOrientation preDeviceOrientation;
    UIInterfaceOrientation previousOrientation;
    CGRect _preFrame;
    bool _bFirst;
}
@end

@implementation TSGameCenterToolbarView

-(void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    previousOrientation = -1;

    _toolBar = [[TSGameCenterToolbar alloc] initWithFrame:CGRectMake(0, 100, isIpad?75:60, isIpad?75:60) menuWidth:isIpad?50:50];
    
    _toolBar.delegate = self;
    
    [self addSubview:_toolBar];
    
    [self sizeToFitOrientation:[self currentOrientation]];
    [self addObservers];
    
}

- (void)dealloc {
    
    [self removeObservers];
}


-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        //自动将事件传递到上一层
        return nil;
    }
    return hitView;
}

#pragma mark - GameCenterToolbarDelegate
- (void)toolbar:(TSGameCenterToolbar *)toolbar didClickMenuAccount:(id)sender
{
    if ([_delegate respondsToSelector:@selector(floatView:didClickMenuAccount:)]) {
        [_delegate floatView:self didClickMenuAccount:sender];
    }
}

#pragma mark - Orientations

- (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation
{
    _preFrame = _toolBar.frame;
    
    [self setTransform:CGAffineTransformIdentity];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    float screenWidth = 0.0f;
    float screenHeight = 0.0f;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        screenWidth = rect.size.height;
        screenHeight = rect.size.width;
        [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        
        [self setCenter:CGPointMake(screenHeight*0.5f, screenWidth*0.5f)];
    }
    else
    {
        screenWidth = rect.size.width;
        screenHeight = rect.size.height;
        [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        
        
        [self setCenter:CGPointMake(screenWidth*0.5f, screenHeight*0.5f)];
    }
    
    if ([[UIDevice currentDevice].systemVersion intValue] > 7) {
        screenWidth = rect.size.width;
        screenHeight = rect.size.height;
        [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    }
    
//    if ([self superview] != nil)
    {
        //if (((int)previousOrientation == (int)previousOrientation) && ((int)[UIDevice currentDevice].orientation) == (int)orientation) {
        if ((UIInterfaceOrientationIsLandscape(previousOrientation) && UIInterfaceOrientationIsPortrait(orientation))
            || (UIInterfaceOrientationIsLandscape(orientation) && UIInterfaceOrientationIsPortrait(previousOrientation))
//            || previousOrientation != orientation
            ) {
            if (IS_IPhoneX_All) { //判断iPhone X
                CGFloat height = 15;
                if (orientation == UIInterfaceOrientationLandscapeRight) { //刘海在左边
                    if (_preFrame.origin.x < 50 ) {
                        //                        }
                        [_toolBar setFrame:CGRectMake(0, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                    else {
                        [_toolBar setFrame:CGRectMake(screenWidth-[_toolBar getLogoWidth], _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                } else if (orientation == UIInterfaceOrientationLandscapeLeft){ //刘海在右边
                    if (_preFrame.origin.x < 50) {
                        [_toolBar setFrame:CGRectMake(0, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                    else {
                        [_toolBar setFrame:CGRectMake(screenWidth-[_toolBar getLogoWidth] - height, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                } else {
                    if (_preFrame.origin.x < 50) {
                        [_toolBar setFrame:CGRectMake(0, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                    else {
                        [_toolBar setFrame:CGRectMake(screenWidth-[_toolBar getLogoWidth], _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                }
            } else {
                if (_preFrame.origin.x < 20) {
                    [_toolBar setFrame:CGRectMake(0, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                }
                else {
                    [_toolBar setFrame:CGRectMake(screenWidth-[_toolBar getLogoWidth], _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                }
            }
            
            
        }
        else
        {
            if (IS_IPhoneX_All) { //判断iPhone X
                CGFloat height = 15;
                if (orientation == UIInterfaceOrientationLandscapeRight) { //刘海在左边
                    if (_preFrame.origin.x < 50 ) {
                        //                        }
                        [_toolBar setFrame:CGRectMake(0, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                    else {
                        [_toolBar setFrame:CGRectMake(screenWidth-[_toolBar getLogoWidth], _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                } else if (orientation == UIInterfaceOrientationLandscapeLeft){ //刘海在右边
                    if (_preFrame.origin.x < 50) {
                        [_toolBar setFrame:CGRectMake(0, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                    else {
                        [_toolBar setFrame:CGRectMake(screenWidth-[_toolBar getLogoWidth] - height, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                } else {
                    if (_preFrame.origin.x < 50) {
                        [_toolBar setFrame:CGRectMake(0, _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                    else {
                        [_toolBar setFrame:CGRectMake(screenWidth-[_toolBar getLogoWidth], _preFrame.origin.y*screenHeight/screenWidth, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
                    }
                }
            } else 
            {
            if (_preFrame.origin.x < 20) {
                [_toolBar setFrame:CGRectMake(0, _preFrame.origin.y, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
            }
            else {
                [_toolBar setFrame:CGRectMake(screenWidth-[_toolBar getLogoWidth], _preFrame.origin.y, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
            }
            }
            
        }
        //[_toolBar setFrame:CGRectMake(0, 0, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
    }
//    else {
//        //[_toolBar setFrame:CGRectMake(0, 0, [_toolBar getLogoWidth], [_toolBar getLogoHeight])];
//    }

    [_toolBar showMenu];
    
    [self setTransform:[self transformForOrientation:orientation]];
    
    preDeviceOrientation = [UIDevice currentDevice].orientation;
    previousOrientation = orientation;
    
    //[_toolBar showMenu:bShowMenu];
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice].systemVersion intValue] > 7)
        return CGAffineTransformIdentity;
	if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
		return CGAffineTransformMakeRotation(-M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
		return CGAffineTransformMakeRotation(M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
		return CGAffineTransformMakeRotation(-M_PI);
	}
    else
    {
		return CGAffineTransformIdentity;
	}
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == previousOrientation)
    {
        return NO;
    }
    else {
        return orientation == UIInterfaceOrientationLandscapeLeft
        || orientation == UIInterfaceOrientationLandscapeRight
        || orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown;
    }
    
    return YES;
}

#pragma mark Obeservers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

#pragma mark - UIDeviceOrientationDidChangeNotification Methods

- (void)deviceOrientationDidChange:(id)object
{
	UIInterfaceOrientation orientation = [self currentOrientation];
	if ([self shouldRotateToOrientation:orientation])
    {
        //BOOL bShowMenu = [_toolBar isMenuShow];
        //[_toolBar showMenu:NO];
        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self sizeToFitOrientation:orientation];
		[UIView commitAnimations];
        //[_toolBar showMenu:bShowMenu];
	}
}
- (void)settoolbarpoint:(CGPoint)point
{
    [_toolBar setbannerIVpoint:point];
}
@end
