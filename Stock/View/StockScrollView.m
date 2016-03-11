//
//  StockScrollView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockScrollView.h"
#import "StockBarView.h"

@interface StockScrollView () <UIScrollViewDelegate, StockBarViewDelegate>

@property (nonatomic, strong)StockBarView* stockBarView;

@property (nonatomic, strong)UIScrollView* scrollView;

@end

@implementation StockScrollView{
    NSInteger page;
}

- (instancetype)initWithViews:(CGRect)frame views:(NSArray *)array{
    self = [super initWithFrame:frame];
    if(self){
        [self initView:array];
    }
    return self;
}

- (void)initView:(NSArray*)views{
    
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.stockBarView];
    [self addSubview:self.scrollView];
    
    UIView* view = views[0];
    CGRect frame = view.frame;
    view.frame = frame;
    [self.scrollView addSubview:view];
    CGFloat x = self.frame.size.width;
    for (int i = 1; i < [views count]; i++) {
        UIView* view = views[i];
        CGRect frame = view.frame;
        frame.origin.x = x * i;
        view.frame = frame;
        [self.scrollView addSubview:view];
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * [views count], self.frame.size.height - 45);
}

#pragma Delegate

- (void)passPageIndex:(NSInteger)pageIndex{
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width * pageIndex, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    page = scrollView.contentOffset.x / self.frame.size.width;
    [self.stockBarView updateView:page];
}

#pragma Private Method

- (StockBarView *)stockBarView{
    if(_stockBarView == nil){
        _stockBarView = [[StockBarView alloc] initWithBarNums:CGRectMake(0, 0, self.frame.size.width, 45) contents:@[@"分时图", @"K线图", @"盘口"]];
        _stockBarView.delegate = self;
    }
    return _stockBarView;
}

- (UIScrollView *)scrollView{
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, self.frame.size.height - 45)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

@end
