//
//  UIColor+Helper.m
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha
{
    unsigned int r, g, b;
    ColorModel *rgb = [self RGBWithHexString:color withAlpha:alpha];
    r = rgb.R;
    g = rgb.G;
    b = rgb.B;
    alpha = rgb.alpha;
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

#pragma mark 16进制转换为RGB模式
+ (ColorModel *) RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return Nil;
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return Nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    ColorModel *rgb = [[ColorModel alloc] init];
    rgb.R = r;
    rgb.B = b;
    rgb.G = g;
    rgb.alpha = alpha;
    return  rgb;
}

@end
