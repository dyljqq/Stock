//
//  KLine.m
//  DDTG
//
//  Created by 季勤强 on 16/5/16.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "KLine.h"

#define KLINE_RED RGB(205, 91, 82)
#define KLINE_GREEN RGB(32, 165, 51)

@implementation KLine

- (instancetype)init{
    self = [super init];
    if (self) {
        _lineWidth = 0.5;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    int index = 0;
    for (NSArray* array in _points) {
        UIColor* color = KLINE_RED;
        UIBezierPath* path = [UIBezierPath bezierPath];
        path.lineWidth = self.lineWidth;
        switch ([self.colors[index] integerValue]) {
            case KLINE_COLOR_RED:
                color = KLINE_RED;
                break;
                
            case KLINE_COLOR_GREEN:
                color = KLINE_GREEN;
                break;
                
            default:
                break;
        }
        [color setStroke];
        [path moveToPoint:CGPointFromString(array[0])];
        [path addLineToPoint:CGPointFromString(array[1])];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        UIBezierPath* clipPath = [path copy];
        [clipPath moveToPoint:CGPointFromString(array[2])];
        [clipPath addLineToPoint:CGPointFromString(array[3])];
        [clipPath addLineToPoint:CGPointFromString(array[4])];
        [clipPath addLineToPoint:CGPointFromString(array[5])];
        [color setFill];
        [clipPath closePath];
        [clipPath addClip];
        
        UIBezierPath* rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [rectPath fill];
        
        CGContextRestoreGState(context);
        
        [path moveToPoint:CGPointFromString(array[6])];
        [path addLineToPoint:CGPointFromString(array[7])];
        [path stroke];
        
        index++;
    }
}

- (void)drawKline:(NSArray *)points colors:(NSArray *)colors{
    _points = points;
    _colors = colors;
    [self setNeedsDisplay];
}

@end
