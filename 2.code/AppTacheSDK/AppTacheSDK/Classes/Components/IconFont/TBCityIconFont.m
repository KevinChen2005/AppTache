//
//  TBCityIconFont.m
//  iCoupon
//
//  Created by John Wong on 10/12/14.
//  Copyright (c) 2014 Taodiandian. All rights reserved.
//

#import "TBCityIconFont.h"
#import <CoreText/CoreText.h>

@implementation TBCityIconFont

static NSString *_fontName;

+ (void)registerFont {
    //获取路径
    NSString * path = [[NSBundle mainBundle] pathForResource:@"AppTacheSDK" ofType:@"bundle"];
    NSString *fontFileUrl = [path stringByAppendingPathComponent:@"iconfont/iconfont.ttf"];
    
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:fontFileUrl], @"Font file doesn't exist");
    
    CFURLRef fontURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)fontFileUrl, kCFURLPOSIXPathStyle, false);
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL(fontURL);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    CGFontRelease(fontRef);
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:[self fontName] size:size];
    if (font == nil) {
        [self registerFont];
        font = [UIFont fontWithName:[self fontName] size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}

+ (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    
}


+ (NSString *)fontName {
    return _fontName ? : @"iconfont";
}

@end
