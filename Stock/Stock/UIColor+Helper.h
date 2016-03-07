//
//  UIColor+Helper.h
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorModel.h"

@interface UIColor (Helper)

+ (UIColor *)colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

+ (ColorModel *)RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

@end
