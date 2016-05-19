//
//  StockDetailView.m
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockDetailView.h"
#import "DashLine.h"
#import "ChooseItemView.h"
#import "SharingTimeView.h"
#import "KLineView.h"
#import "KLineModel.h"
#import "KLineStockModel.h"

static const CGFloat SCROLLVIEW_MAX_SCALE = 2.0;
static const CGFloat SCROLLVIEW_MIN_SCALE = 1.0;

@interface StockDetailView () <ChooseItemViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)UILabel* currentPriceLabel;
@property (nonatomic, strong)UILabel* riseLabel;
@property (nonatomic, strong)UILabel* increaseLabel;
@property (nonatomic, strong)UILabel* timeLabel;

@property (nonatomic, strong)ChooseItemView* chooseItemView;

@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)SharingTimeView* sharingTimeView;
@property (nonatomic, strong)KLineView* kLineView;

@end

@implementation StockDetailView{
    NSMutableArray* tapeLabels;
    NSMutableArray* tapeContents;
    CGFloat currentScale;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    tapeContents = [NSMutableArray arrayWithObjects:@"今开 --", @"昨收 --", @"最高 --", @"最低 --", @"成交量 --", @"成交额 --", @"涨停价 --", @"跌停价 --", @"卖5 -- --", @"卖4 -- --", @"卖3 -- --", @"卖2 -- --", @"卖1 -- --", @"买1 -- --", @"买2 -- --", @"买3 -- --", @"买4 -- --", @"买5 -- --", nil];
    tapeLabels = [NSMutableArray array];
    
    [self addSubview:self.currentPriceLabel];
    [self addSubview:self.riseLabel];
    [self addSubview:self.increaseLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.chooseItemView];
    [self addSubview:self.scrollView];
    [self addTapeLabels];
    
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(LeftSpacing);
    }];
    [self.riseLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.bottom.equalTo(self.currentPriceLabel.mas_centerY);
        make.left.equalTo(self.currentPriceLabel.mas_right).offset(5);
    }];
    [self.increaseLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.equalTo(self.currentPriceLabel.mas_centerY);
        make.left.equalTo(self.riseLabel);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.equalTo(self.currentPriceLabel.mas_bottom).offset(8);
        make.left.equalTo(self.currentPriceLabel);
    }];
    [self.chooseItemView mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.equalTo(self.timeLabel.mas_bottom).offset(50);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker* make){
        make.right.equalTo(self);
        make.top.equalTo(self.chooseItemView.mas_bottom).offset(5);
        make.left.equalTo(self);
        make.height.mas_equalTo(200);
    }];
    UIView* container = [UIView new];
    container.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView.mas_height);
    }];

    NSArray* array = @[self.sharingTimeView, self.kLineView];
    UIView* lastView = nil;
    for (int i = 0; i < 2; i++) {
        UIView* view = array[i];
        [container addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker* make){
            make.top.and.bottom.equalTo(container);
            make.width.equalTo(self.scrollView);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            }else{
                make.left.equalTo(container.mas_left);
            }
        }];
        
        lastView = view;
    }
    [container mas_makeConstraints:^(MASConstraintMaker* make){
        make.right.equalTo(lastView.mas_right);
    }];
}

- (void)updateTape:(NSArray *)tapes{
    for (int i = 0; i < [tapeLabels count]; i++) {
        UILabel* label = tapeLabels[i];
        label.text = tapes[i];
        NSInteger loc = [label.text rangeOfString:@" "].location;
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attr addAttribute:NSForegroundColorAttributeName value:TextFontColor range:NSMakeRange(loc, label.text.length - loc)];
        label.attributedText = attr;
    }
    [self.sharingTimeView updateTapeView:[tapes subarrayWithRange:NSMakeRange(8, tapes.count - 8)]];
}

- (void)updateSharingTime:(id)model{
    [self.sharingTimeView updateView:model];
}

- (void)updateKLine:(KLineModel*)model{
    if ([model.stockArray count] > 0) {
        self.currentPriceLabel.text = [NSString stringWithFormat:@"%.2f", model.currentValue];
        KLineStockModel* stockModel = model.stockArray[model.kCount - 2];
        CGFloat rise = stockModel.openPrice;//昨日收盘价
        if (rise - model.currentValue > 0) {
            self.riseLabel.text = [NSString stringWithFormat:@"%.2f", model.currentValue - rise];
            self.increaseLabel.text = [NSString stringWithFormat:@"%.2f%%", (model.currentValue - rise)/rise * 100];
        }else{
            self.riseLabel.text = [NSString stringWithFormat:@"+%.2f", model.currentValue - rise];
            self.increaseLabel.text = [NSString stringWithFormat:@"+%.2f%%", (model.currentValue - rise)/rise * 100];
        }
    }else{
        self.currentPriceLabel.text = @"-- --";
        self.riseLabel.text = @"--";
        self.increaseLabel.text = @"--";
    }
    [self.kLineView updateView:model];
}

#pragma Delegate

- (void)chooseItemViewDidSelect:(NSInteger)index{
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * index, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self.chooseItemView itemDidChooseByIndex:index];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    currentScale = scale;
}

- (void)doubleGesture:(UITapGestureRecognizer*)doubleTap{
    if (currentScale == SCROLLVIEW_MAX_SCALE) {
        currentScale = SCROLLVIEW_MIN_SCALE;
    }else if(currentScale == SCROLLVIEW_MIN_SCALE){
        currentScale = SCROLLVIEW_MAX_SCALE;
    }
    CGFloat averageScale = SCROLLVIEW_MIN_SCALE + (SCROLLVIEW_MAX_SCALE - SCROLLVIEW_MIN_SCALE) / 2.0;
    if (currentScale >= averageScale) {
        currentScale = SCROLLVIEW_MAX_SCALE;
    }else{
        currentScale =SCROLLVIEW_MIN_SCALE;
    }
    [self.scrollView setZoomScale:currentScale animated:YES];
}

#pragma Private Method

- (void)addTapeLabels{
    
    UILabel* lastLabel = nil;
    //盘口数据
    for (int i = 0; i < 8; i++) {
        UILabel* label = [UILabel new];
        label.text = tapeContents[i];
        label.textColor = TextGrayColor;
        label.font = Font(9);
        [self addSubview:label];
        
        NSInteger loc = [label.text rangeOfString:@" "].location;
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attr addAttribute:NSForegroundColorAttributeName value:TextFontColor range:NSMakeRange(loc, label.text.length - loc)];
        label.attributedText = attr;
        
        [label mas_makeConstraints:^(MASConstraintMaker* make){
            if (i % 2 == 0) {
                make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
                if (i == 0) {
                    make.left.mas_equalTo(LeftSpacing);
                }else{
                    make.left.equalTo(lastLabel.mas_right);
                }
            }else{
                make.top.equalTo(lastLabel.mas_bottom).offset(10);
                make.left.equalTo(lastLabel.mas_left);
            }
            make.width.equalTo(self).multipliedBy(0.25).offset(-LeftSpacing / 2);
        }];
        
        lastLabel = label;
        [tapeLabels addObject:label];
    }
}

- (NSString*)getCurrentTime{
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    
    NSDate* date = [NSDate date];
    NSString* currentTime = [formatter stringFromDate:date];
    return currentTime;
}

#pragma Getter/Setter

- (UILabel *)currentPriceLabel{
    if(_currentPriceLabel == nil){
        _currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 22.5, 100, 36)];
        _currentPriceLabel.textColor = NavColor;
        _currentPriceLabel.font = Font(34);
        _currentPriceLabel.text = @"-- --";
    }
    return _currentPriceLabel;
}

- (UILabel *)riseLabel{
    if(_riseLabel == nil){
        _riseLabel = [UILabel new];
        _riseLabel.textColor = NavColor;
        _riseLabel.font = Font(9.5);
        _riseLabel.text = @"--";
    }
    return _riseLabel;
}

- (UILabel *)increaseLabel{
    if(_increaseLabel == nil){
        _increaseLabel = [UILabel new];
        _increaseLabel.textColor = NavColor;
        _increaseLabel.font = Font(9.5);
        _increaseLabel.text = @"--";
    }
    return _increaseLabel;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RGB(121, 121, 121);
        _timeLabel.font = Font(9);
        _timeLabel.text = [self getCurrentTime];
    }
    return _timeLabel;
}

- (ChooseItemView *)chooseItemView{
    if (_chooseItemView == nil) {
        _chooseItemView = [[ChooseItemView alloc] initWithArray:@[@"分时图", @"K线图"]];
        _chooseItemView.delegate = self;
        _chooseItemView.backgroundColor = BACKGROUND_COLOR;
    }
    return _chooseItemView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.maximumZoomScale = SCROLLVIEW_MAX_SCALE;
        _scrollView.minimumZoomScale = SCROLLVIEW_MIN_SCALE;
        _scrollView.decelerationRate = 1.0;
    }
    return _scrollView;
}

- (SharingTimeView *)sharingTimeView{
    if (_sharingTimeView == nil) {
        _sharingTimeView = [SharingTimeView new];
        _sharingTimeView.layer.borderColor = LINE_COLOR.CGColor;
        _sharingTimeView.layer.borderWidth = 0.5;
    }
    return _sharingTimeView;
}

- (KLineView *)kLineView{
    if (_kLineView == nil) {
        _kLineView = [KLineView new];
        _kLineView.layer.borderColor = LINE_COLOR.CGColor;
        _kLineView.layer.borderWidth = 0.5;
        
        UITapGestureRecognizer *doubelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGesture:)];
        doubelGesture.numberOfTapsRequired = 2;
        [_kLineView addGestureRecognizer:doubelGesture];
    }
    return _kLineView;
}

@end
