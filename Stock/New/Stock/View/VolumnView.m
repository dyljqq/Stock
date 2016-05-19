//
//  VolumnView.m
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "VolumnView.h"

@implementation VolumnView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lineWidth = 1;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    if([self.volumns count] <= 0)
        return ;
    const CGFloat* redColors = CGColorGetComponents(RGB(205, 91, 82).CGColor);
    const CGFloat* grayColors = CGColorGetComponents(RGB(32, 165, 51).CGColor);
    for (int i = 0; i < [self.volumns count]; i++) {
        CGPoint startPoint = CGPointFromString(self.volumns[i][0]);
        CGPoint endPoint = CGPointFromString(self.volumns[i][1]);
        switch ([self.lineColors[i] integerValue]) {
            case VOLUMN_VIEW_COLOR_RED:
            {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(context, self.lineWidth);
                CGContextSetRGBStrokeColor(context, redColors[0], redColors[1], redColors[2], 1);
                CGContextSetShouldAntialias(context, YES);
                CGContextMoveToPoint(context, startPoint.x, startPoint.y);
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
                break;
                
            case VOLUMN_VIEW_COLOR_GREEN:
            {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(context, self.lineWidth);
                CGContextSetRGBStrokeColor(context, grayColors[0], grayColors[1], grayColors[2], 1.0);
                CGContextMoveToPoint(context, startPoint.x, startPoint.y);
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
                
            default:
                break;
        }
    }
}

- (void)drawVolumn:(NSArray *)volumns colors:(NSArray *)colors{
    _volumns = volumns;
    _lineColors = colors;
    [self setNeedsDisplay];
}

@end
