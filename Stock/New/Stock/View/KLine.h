//
//  KLine.h
//  DDTG
//
//  Created by 季勤强 on 16/5/16.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KLINE_COLOR_RED,
    KLINE_COLOR_GREEN,
} KLINE_COLOR;

@interface KLine : UIView

@property (nonatomic)CGFloat lineWidth;

@property (nonatomic, copy, readonly)NSArray* points;
@property (nonatomic, copy, readonly)NSArray* colors;

- (void)drawKline:(NSArray*)points colors:(NSArray*)colors;

@end
