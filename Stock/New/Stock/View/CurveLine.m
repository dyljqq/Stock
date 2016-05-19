//
//  CurveLine.m
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "CurveLine.h"

@implementation CurveLine

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = 1.0;
        self.lineColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    if ([self.points count] == 0) {
        return ;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint point = CGPointFromString(self.points[0]);
    [path moveToPoint:point];
    for (int i = 1; i < [self.points count]; i++) {
        CGPoint p = CGPointFromString(self.points[i]);
        [path addLineToPoint:p];
    }
    path.lineWidth = self.lineWidth;
    [self.lineColor setStroke];
    [path stroke];
    
    if (self.isClothPath) {
        CGContextSaveGState(context);
        
        UIBezierPath* clipPath = [path copy];
        CGPoint endPoint = CGPointFromString(self.points[self.points.count - 1]);
        [clipPath addLineToPoint:CGPointMake(endPoint.x, rect.size.height)];
        [clipPath addLineToPoint:CGPointMake(0, rect.size.height)];
        [clipPath closePath];
        [clipPath addClip];
        
        [RGB(205, 223, 250) setFill];
        UIBezierPath* rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [rectPath fill];
        
        CGContextRestoreGState(context);
    }
}

- (void)setPoints:(NSArray *)points{
    _points = points;
    [self setNeedsDisplay];
}

@end
