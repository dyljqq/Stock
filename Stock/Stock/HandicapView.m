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

- (void)updateViewIfNoData{
    int index = 0;
    NSMutableArray* contents = [NSMutableArray array];
    NSMutableArray* colors = [NSMutableArray array];
    while (index < 10) {
        NSMutableArray* arr = [NSMutableArray array];
        [arr addObject:[NSString stringWithFormat:@"卖--"]];
        [arr addObject:@"--"];
        [arr addObject:@"--"];
        index += 2;
        [contents addObject:arr];
        [colors addObject:@[TextFontColor, NavColor, NavColor]];
    }
    index = 0;
    while (index < 10) {
        NSMutableArray* arr = [NSMutableArray array];
        [arr addObject:[NSString stringWithFormat:@"买 --"]];
        [arr addObject:@"--"];
        [arr addObject:@"--"];
        index += 2;
        [contents addObject:arr];
        [colors addObject:@[TextFontColor, RGB(76, 209, 207), TextGrayColor]];
    }
    [contents addObject:@[@"今开", @"--"]];
    [colors addObject:@[TextFontColor, NavColor]];
    [contents addObject:@[@"昨收", @"--"]];
    [colors addObject:@[TextFontColor, NavColor]];
    [contents addObject:@[@"最高", @"--"]];
    [colors addObject:@[TextFontColor, NavColor]];
    [contents addObject:@[@"最低", @"--"]];
    [colors addObject:@[TextFontColor, RGB(76, 209, 207)]];
    [contents addObject:@[@"振幅", @"--"]];
    [colors addObject:@[TextFontColor, NavColor]];
    [contents addObject:@[@"涨停价", @"--"]];
    [colors addObject:@[TextFontColor, NavColor]];
    [contents addObject:@[@"跌停价", @"--"]];
    [colors addObject:@[TextFontColor, RGB(76, 209, 207)]];
    [self updateView:contents textColors:colors];
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
        if(i % 5 == 4){
            if(i == 4){
                UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, y + 22, self.frame.size.width, 1)];
                line.backgroundColor = LINE_COLOR;
                [self addSubview:line];
            }
            y += 30;
        }else{
            y += 20;
        }
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
