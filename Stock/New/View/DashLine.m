//
//  DashLine.m
//  DDTG
//
//  Created by 季勤强 on 16/5/12.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "DashLine.h"

@implementation DashLine

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, TextGrayColor.CGColor);
    CGFloat lengths[] = {4, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width + rect.origin.x, 0);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

@end
