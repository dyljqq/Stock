//
//  SharingPlansLine.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//

#import "SharingPlansLine.h"

@implementation SharingPlansLine

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initParams];
    }
    return self;
}

- (void)initParams{
    self.backgroundColor = [UIColor clearColor];
    self.lineWidth = 1.0;
    self.lineColor = TextGrayColor;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();    
    if(_isDash){
        [self drawDash:context];
        return;
    }else if(_isVertical){
        [self drawVertical];
        return ;
    }
    if(_isStraight){
        [self drawStraightLine:context];
    }else{
        [self drawLine];
    }
}

#pragma Private Method

- (void)drawStraightLine:(CGContextRef)context{
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetShouldAntialias(context, YES);
    const CGFloat* colors = CGColorGetComponents(self.lineColor.CGColor);
    CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], 1);
    const CGPoint points[] = {self.startPoint, self.endPoint};
    CGContextStrokeLineSegments(context, points, 2);
//    CGContextClosePath(context);
}

- (void)drawLine{
    if([self.linePoints count] <= 0)
        return ;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGPoint point = CGPointFromString(self.linePoints[0]);
    CGContextMoveToPoint(context, point.x, point.y);
    for (int i = 1; i < [self.linePoints count]; i++) {
        CGPoint p = CGPointFromString(self.linePoints[i]);
        CGContextAddLineToPoint(context, p.x, p.y);
    }
    [self.lineColor setStroke];
    [[UIColor clearColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
//    CGContextClosePath(context);
}

- (void)drawVertical{
    if([self.linePoints count] <= 0)
        return ;
    const CGFloat* redColors = CGColorGetComponents([UIColor redColor].CGColor);
    const CGFloat* grayColors = CGColorGetComponents([UIColor lightGrayColor].CGColor);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < [self.linePoints count]; i++) {
        CGPoint startPoint = CGPointFromString(self.linePoints[i][0]);
        CGPoint endPoint = CGPointFromString(self.linePoints[i][1]);
        switch ([self.verticalColors[i] integerValue]) {
            case SHARING_PLAN_VERTICAL_COLOR_RED:
            {
                CGContextSetLineWidth(context, self.lineWidth);
                CGContextSetRGBStrokeColor(context, redColors[0], redColors[1], redColors[2], 1);
                CGContextSetShouldAntialias(context, YES);
                CGContextMoveToPoint(context, startPoint.x, startPoint.y);
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
                break;
                
            case SHARING_PLAN_VERTICAL_COLOR_GREEN:
            {
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
//    CGContextClosePath(context);
}

- (void)drawDash:(CGContextRef)context{
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context,0.5);//线宽度
    
    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
    
    CGFloat lengths[] = {4,2};//先画4个点再画2个点
    
    CGContextSetLineDash(context, 0, lengths, 2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(context,self.startPoint.x,self.startPoint.y);
    
    CGContextAddLineToPoint(context,self.endPoint.x,self.endPoint.y);
    
    CGContextStrokePath(context);
    
//    CGContextClosePath(context);
}

@end
