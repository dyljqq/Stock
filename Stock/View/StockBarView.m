//
//  StockBarView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockBarView.h"

@implementation StockBarView{
    NSMutableArray* barsArray;
    int tag;
    NSInteger origin;
}

- (instancetype)initWithBarNums:(CGRect)frame contents:(NSArray *)array{
    self = [super initWithFrame:frame];
    if(self){
        [self initView:frame contents:array];
    }
    return self;
}

- (void)initView:(CGRect)frame contents:(NSArray*)array{
    origin = -1;
    self.backgroundColor = [UIColor whiteColor];
    
    barsArray = [NSMutableArray array];
    NSInteger num = [array count];
    
    CGFloat x = 0;
    for (int i = 0; i < num; i++) {
        [self addView:CGRectMake(x, 0, frame.size.width/num, frame.size.height) content:array[i]];
        x += frame.size.width/num;
    }
    [self updateView:0];
}

- (void)updateView:(NSInteger)page{
    if(origin == page)
        return ;
    
    if (origin < 0) {
        origin = 0;
    }
    
    UIView* originView = barsArray[origin];
    ((UILabel*)[originView viewWithTag:8888]).textColor = TextGrayColor;
    [originView viewWithTag:8889].hidden = YES;
    
    UIView* currentView = barsArray[page];
    ((UILabel*)[currentView viewWithTag:8888]).textColor = NavColor;
    [currentView viewWithTag:8889].hidden = NO;
    
    origin = page;
}

#pragma Action

- (void)tapAction:(UITapGestureRecognizer*)tap{
    NSInteger t = tap.view.tag;
    [self updateView:t];
    [self.delegate passPageIndex:t];
}

#pragma Private Method

- (void)addView:(CGRect)frame content:(NSString*)content{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = tag++;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.height - 16)/2, frame.size.width, 16)];
    label.text = content;
    label.textColor = TextGrayColor;
    label.font = Font(15);
    label.tag = 8888;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15, frame.size.height - 2, frame.size.width - 30, 2)];
    line.backgroundColor = NavColor;
    line.hidden = YES;
    line.tag = 8889;
    [view addSubview:line];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [view addGestureRecognizer:tap];
    view.userInteractionEnabled = YES;
    
    [barsArray addObject:view];
    [self addSubview:view];
}

@end
