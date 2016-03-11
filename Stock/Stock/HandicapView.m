//
//  HandicapView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "HandicapView.h"

@implementation HandicapView

- (instancetype)initWithArray:(CGRect)frame dataArray:(NSArray *)array textColors:(NSArray*)colors{
    self = [super initWithFrame:frame];
    if(self){
        [self initView:array colors:colors];
    }
    return self;
}

- (void)updateView:(NSArray *)array textColors:(NSArray *)colors{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    [self initView:array colors:colors];
}

- (void)initView:(NSArray*)array colors:(NSArray*)colors{
    self.backgroundColor = [UIColor clearColor];
    CGFloat x = 15, y = 0;
    for (int i = 0; i < [array count]; i++) {
        if(i == 10){
            x = APPLICATION_SIZE.width / 2 + 15;
            y = 0;
        }
        [self addView:CGRectMake(x, y, APPLICATION_SIZE.width / 2, 14) contents:array[i] colors:colors[i]];
        y += 20;
    }
}

#pragma Private Method

- (void)addView:(CGRect)frame contents:(NSArray*)contents colors:(NSArray*)colors{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    CGFloat x = 0;
    for (int i = 0; i < [contents count]; i++) {
        float width = [HandleString lableWidth:contents[i] withSize:CGSizeMake(50, 14) withFont:Font(13)];
        [view addSubview:[self addLabel:CGRectMake(x, 0, width, 14) content:contents[i] textColor:colors[i]]];
        x += width + 24;
    }
    [self addSubview:view];
}

- (UILabel*)addLabel:(CGRect)frame content:(NSString*)content textColor:(UIColor*)color{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = content;
    label.textColor = color;
    label.font = Font(13);
    return label;
}

@end
