//
//  SharingPlansView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "SharingPlansView.h"
#import "SharingPlansLine.h"
#import "KLine.h"
#import "StockBoxView.h"

@interface SharingPlansView ()

@property (nonatomic, strong)UILabel* stockNameLabel;
@property (nonatomic, strong)UILabel* contentLabel;
@property (nonatomic, strong)UILabel* timeLabel;

@property (nonatomic, strong)UIView* mainBoxView;

@property (nonatomic, strong)SharingPlansLine* currentLine;
@property (nonatomic, strong)SharingPlansLine* dashLine;
@property (nonatomic, strong)SharingPlansLine* averageLine;

@property (nonatomic, strong)UIView* volumnsView;
@property (nonatomic, strong)SharingPlansLine* volumnLine;

@property (nonatomic, strong)StockBoxView* stockBoxView;

@property (nonatomic, strong)UIView* lineView;

@end

@implementation SharingPlansView{
    NSMutableArray* mainLeftLabels;
    NSMutableArray* mainRightLabels;
    NSMutableArray* volumsLabels;
    SharingPlanModel* planModel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainBoxView];
    [self addSubview:self.volumnsView];
    
    CGFloat y = 0;
    for (int i = 0; i < 7; i++) {
        y += self.mainBoxView.frame.size.height / 8;
        SharingPlansLine* line = [[SharingPlansLine alloc] initWithFrame:CGRectMake(0, 0, self.mainBoxView.frame.size.width, self.mainBoxView.frame.size.height)];
        line.isStraight = YES;
        line.lineWidth = 1;
        line.lineColor = LINE_COLOR;
        line.startPoint = CGPointMake(0, y);
        line.endPoint = CGPointMake(self.mainBoxView.frame.size.width, y);
        [self.mainBoxView addSubview:line];
    }
    
    y = 0;
    for (int i = 0; i < 7; i++) {
        y += self.volumnsView.frame.size.height / 4;
        SharingPlansLine* line = [[SharingPlansLine alloc] initWithFrame:CGRectMake(0, 0, self.volumnsView.frame.size.width, self.volumnsView.frame.size.height)];
        line.isStraight = YES;
        line.lineWidth = 1;
        line.lineColor = LINE_COLOR;
        line.startPoint = CGPointMake(0, y);
        line.endPoint = CGPointMake(self.mainBoxView.frame.size.width, y);
        [self.volumnsView addSubview:line];
    }
    
    [self addSubview:self.stockNameLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    
    float width = [HandleString lableWidth:@"2015-03-07 14:33:24" withSize:CGSizeMake(100, 13) withFont:Font(8)] + 5;
    self.timeLabel.frame = CGRectMake(self.mainBoxView.frame.size.width + self.mainBoxView.frame.origin.x - width, 5, width, 9);
    
    mainLeftLabels = [NSMutableArray array];
    y = self.mainBoxView.frame.origin.y - 5;
    for (int i = 0; i < 9; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 30, 10)];
        if(i < 4){
            label.textColor = NavColor;
        }else if(i > 4){
            label.textColor = [UIColor greenColor];
        }else{
            label.textColor = TextFontColor;
        }
        label.font = Font(8);
        label.textAlignment = NSTextAlignmentRight;
        [mainLeftLabels addObject:label];
        [self addSubview:label];
        y += self.mainBoxView.frame.size.height / 8;
    }
    
    mainRightLabels = [NSMutableArray array];
    y = self.mainBoxView.frame.origin.y - 5;
    for (int i = 0; i < 9; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(self.mainBoxView.frame.size.width + self.mainBoxView.frame.origin.x + 5, y, 35, 10)];
        if(i < 4){
            label.textColor = NavColor;
        }else if(i > 4){
            label.textColor = [UIColor greenColor];
        }else{
            label.textColor = TextFontColor;
        }
        label.font = Font(8);
        label.textAlignment = NSTextAlignmentLeft;
        [mainRightLabels addObject:label];
        [self addSubview:label];
        y += self.mainBoxView.frame.size.height / 8;
    }
    
    volumsLabels = [NSMutableArray array];
    y = self.volumnsView.frame.origin.y - 3;
    for (int i = 0; i < 5; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 35, 10)];
        label.textColor = TextGrayColor;
        label.font = Font(8);
        label.textAlignment = NSTextAlignmentRight;
        [volumsLabels addObject:label];
        [self addSubview:label];
        y += self.volumnsView.frame.size.height / 4;
    }
    [self.volumnsView addSubview:self.volumnLine];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(self.volumnsView.frame.origin.x, self.volumnsView.frame.origin.y - 14, 100, 10)];
    label.text = @"单位：万";
    label.textColor = TextGrayColor;
    label.font = Font(8);
    [self addSubview:label];
    
    [self.mainBoxView addSubview:self.currentLine];
    [self.mainBoxView addSubview:self.averageLine];
    [self.mainBoxView addSubview:self.dashLine];
    [self.mainBoxView addSubview:self.lineView];
    [self.mainBoxView addSubview:self.stockBoxView];
}

- (void)updateViewIfNoData{
    
}

- (void)updateView:(SharingPlanModel*)model{
    
    planModel = model;
    
    if([BaseMethod isNOTNull:model.symbol]){
        self.stockNameLabel.text = [NSString stringWithFormat:@"sh%@", model.symbol];
    }else{
        self.stockNameLabel.text = @"--";
    }
    float width = [HandleString lableWidth:self.stockNameLabel.text withSize:CGSizeMake(100, 10) withFont:Font(8)];
    self.stockNameLabel.frame = CGRectMake(self.mainBoxView.frame.origin.x, 5, width, 9);
    self.contentLabel.frame = CGRectMake(self.stockNameLabel.frame.size.width + self.stockNameLabel.frame.origin.x + 30, 5, 150, 9);
    
    NSMutableArray* current = [NSMutableArray array];
    CGFloat x = 0;
    CGFloat max = MAX(ABS(model.maxValue - model.yesterdayClosePrice), ABS(model.yesterdayClosePrice - model.minValue));
    max = max ? max : 0.5;
    CGFloat valueSpace = max/4.0;
    CGFloat space = 1.0 * self.mainBoxView.frame.size.width/[model.currentPriceArray count];
    CGFloat spaceY = self.mainBoxView.frame.size.height/(8.0 * valueSpace);
    CGFloat y = self.mainBoxView.frame.size.height / 2;
    for (int i = 0; i < [model.currentPriceArray count]; i++) {
        CGFloat value = model.yesterdayClosePrice + max - [model.currentPriceArray[i] floatValue];
        NSString* p = [NSString stringWithFormat:@"{%.2f,%.2f}", x, value * spaceY];
        [current addObject:p];
        x += space;
    }
    self.currentLine.linePoints = current;
    [self.currentLine setNeedsDisplay];
    
    NSInteger size = [mainLeftLabels count];
    for (int i = 0; i < [mainLeftLabels count]; i++) {
        UILabel* leftLabel = (UILabel*)mainLeftLabels[i];
        UILabel* rightLabel = (UILabel*)mainRightLabels[i];
        if([model.currentPriceArray count] > 0){
            leftLabel.text = [NSString stringWithFormat:@"%.2f", (size/2 - i) * valueSpace + model.yesterdayClosePrice];
            rightLabel.text = [NSString stringWithFormat:@"%.2f%%", ((size/2 - i) * valueSpace) / model.yesterdayClosePrice * 100];
        }else{
            leftLabel.text = @"";
            rightLabel.text = @"";
        }
    }
    
    self.dashLine.startPoint = CGPointMake(0, self.mainBoxView.frame.size.height/2);
    self.dashLine.endPoint = CGPointMake(self.mainBoxView.frame.size.width, self.mainBoxView.frame.size.height/2);
    [self.dashLine setNeedsDisplay];
    
    [current removeAllObjects];
    y = self.mainBoxView.frame.size.height / 2;
    x = 0;
    for (int i = 0; i < [model.averagePriceArray count]; i++) {
        CGFloat value = model.yesterdayClosePrice + max - [model.averagePriceArray[i] floatValue];
        NSString* p = [NSString stringWithFormat:@"{%.2f,%.2f}", x, value * spaceY];
        [current addObject:p];
        x += space;
    }
    self.averageLine.linePoints = current;
    [self.averageLine setNeedsDisplay];
    
    CGFloat volumSpace = (model.maxVolum - model.minVolum)/4;
    volumSpace = volumSpace ? volumSpace : 25000;
    for (int i = 0; i < [volumsLabels count]; i++) {
        UILabel* label = (UILabel*)volumsLabels[i];
        if([model.volumnsArray count] > 0){
            label.text = [NSString stringWithFormat:@"%.2f", volumSpace * ([volumsLabels count] - i - 1)/1000];
        }else{
            label.text = @"";
        }
    }
    
    x = 0;
    y = self.volumnsView.frame.size.height;
    volumSpace = (model.maxVolum - model.minVolum);
    space = volumSpace ? y / (model.maxVolum - model.minVolum) : 1;
    [current removeAllObjects];
    self.volumnLine.lineWidth = self.volumnsView.frame.size.width/242 - 0.5;
    NSMutableArray* verticalLineColorArray = [NSMutableArray arrayWithObject:[NSNumber numberWithInteger:SHARING_PLAN_VERTICAL_COLOR_RED]];
    for (int i = 1; i < [model.volumnsArray count]; i++) {
        NSString* startPoint = [NSString stringWithFormat:@"{%.2f,%.2f}", x, y];
        long volumn = [model.volumnsArray[i] floatValue] > 0 ? [model.volumnsArray[i] floatValue] : y;
        NSString* endPoint = [NSString stringWithFormat:@"{%.2f,%.2f}", x, volumn * space];
        NSArray* array = @[startPoint, endPoint];
        [current addObject:array];
        if([model.currentPriceArray[i] floatValue] >= [model.currentPriceArray[i - 1] floatValue]){
            [verticalLineColorArray addObject:[NSNumber numberWithInteger:SHARING_PLAN_VERTICAL_COLOR_RED]];
        }else{
            [verticalLineColorArray addObject:[NSNumber numberWithInteger:SHARING_PLAN_VERTICAL_COLOR_GREEN]];
        }
        x += 1.5;
    }
    self.volumnLine.linePoints = [current copy];
    self.volumnLine.verticalColors = [verticalLineColorArray copy];
    [self.volumnLine setNeedsDisplay];
}

#pragma Action

- (void)mainTapAction:(UITapGestureRecognizer*)tap{
    CGPoint point = [tap locationInView:tap.view];
    if(point.x < 0 || point.x > self.mainBoxView.frame.size.width)
        return ;
    
    if(tap.state == UIGestureRecognizerStateBegan || tap.state == UIGestureRecognizerStateChanged){
        [self hideView:NO];
        CGRect frame = self.lineView.frame;
        frame.origin.x = point.x;
        self.lineView.frame = frame;
        self.lineView.hidden = NO;
        
        CGFloat space = 1.0 * self.mainBoxView.frame.size.width/[planModel.currentPriceArray count];
        int index = point.x / space;
        if(index >= 0 && index < [planModel.currentPriceArray count]){
            NSString* time = [NSString stringWithFormat:@"%@:%@", [planModel.timesArray[index] substringToIndex:2], [planModel.timesArray[index] substringFromIndex:2]];
            NSString* arise = [NSString stringWithFormat:@"%.2f%%", ([planModel.currentPriceArray[index] floatValue] - planModel.yesterdayClosePrice)/planModel.yesterdayClosePrice * 100];
            NSArray* array = @[time, planModel.currentPriceArray[index], arise, planModel.volumnsArray[index]];
            [self.stockBoxView updateView:array];
            
            self.stockBoxView.hidden = NO;
            frame = self.stockBoxView.frame;
            if(point.x < self.mainBoxView.frame.size.width/2){
                frame.origin.x = self.mainBoxView.frame.size.width - 65;
            }else{
                frame.origin.x = 5;
            }
            self.stockBoxView.frame = frame;
        }
    }else{
        [self hideView:YES];
    }
}

#pragma Private Method

- (UIView *)mainBoxView{
    if(_mainBoxView == nil){
        _mainBoxView = [[UIView alloc] initWithFrame:CGRectMake(40, 20, APPLICATION_SIZE.width - 80, 100)];
        _mainBoxView.backgroundColor = [UIColor whiteColor];
        _mainBoxView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _mainBoxView.layer.borderWidth = 1;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainTapAction:)];
        [_mainBoxView addGestureRecognizer:tap];
        _mainBoxView.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [longPressGestureRecognizer addTarget:self action:@selector(mainTapAction:)];
        [longPressGestureRecognizer setMinimumPressDuration:0.3f];
        [longPressGestureRecognizer setAllowableMovement:50.0];
        [_mainBoxView addGestureRecognizer:longPressGestureRecognizer];
    }
    return _mainBoxView;
}

- (SharingPlansLine *)currentLine{
    if(_currentLine == nil){
        _currentLine = [[SharingPlansLine alloc] initWithFrame:self.mainBoxView.bounds];
        _currentLine.lineColor = RGB(76, 209, 207);
        _currentLine.lineWidth = 1;
    }
    return _currentLine;
}

- (SharingPlansLine *)dashLine{
    if(_dashLine == nil){
        _dashLine = [[SharingPlansLine alloc] initWithFrame:self.mainBoxView.bounds];
        _dashLine.lineColor = TextFontColor;
        _dashLine.lineWidth = 1;
        _dashLine.isDash = YES;
    }
    return _dashLine;
}

- (SharingPlansLine *)averageLine{
    if(_averageLine == nil){
        _averageLine = [[SharingPlansLine alloc] initWithFrame:self.mainBoxView.bounds];
        _averageLine.lineColor = TextFontColor;
        _averageLine.lineWidth = 1;
    }
    return _averageLine;
}

- (UILabel *)stockNameLabel{
    if(_stockNameLabel == nil){
        _stockNameLabel = [UILabel new];
        _stockNameLabel.textColor = TextFontColor;
        _stockNameLabel.font = Font(8);
    }
    return _stockNameLabel;
}

- (UILabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [UILabel new];
        _contentLabel.text = @"-价格 -均线";
        _contentLabel.textColor = TextFontColor;
        _contentLabel.font = Font(8);
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
        [attr addAttribute:NSForegroundColorAttributeName value:RGB(76, 209, 207) range:NSMakeRange(0, 3)];
        _contentLabel.attributedText = attr;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel{
    if(_timeLabel == nil){
        _timeLabel = [UILabel new];
        _timeLabel.textColor = TextFontColor;
        _timeLabel.font = Font(8);
        NSDateFormatter* fommater = [NSDateFormatter new];
        fommater.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        _timeLabel.text = [fommater stringFromDate:[NSDate date]];
    }
    return _timeLabel;
}

- (UIView *)volumnsView{
    if(_volumnsView == nil){
        _volumnsView = [[UIView alloc] initWithFrame:CGRectMake(40, self.mainBoxView.frame.size.height + self.mainBoxView.frame.origin.y + 20, APPLICATION_SIZE.width - 80, 50)];
        _volumnsView.backgroundColor = [UIColor whiteColor];
        _volumnsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _volumnsView.layer.borderWidth = 1;
    }
    return _volumnsView;
}

- (SharingPlansLine *)volumnLine{
    if(_volumnLine == nil){
        _volumnLine = [[SharingPlansLine alloc] initWithFrame:self.volumnsView.bounds];
        _volumnLine.lineColor = [UIColor redColor];
        _volumnLine.lineWidth = 1;
        _volumnLine.isVertical = YES;
    }
    return _volumnLine;
}

- (StockBoxView *)stockBoxView{
    if(_stockBoxView == nil){
        _stockBoxView = [[StockBoxView alloc] initWithFrame:CGRectMake(5, 5, 60, 50)];
        _stockBoxView.hidden = YES;
    }
    return _stockBoxView;
}

- (UIView *)lineView{
    if(_lineView == nil){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.mainBoxView.frame.size.height)];
        _lineView.backgroundColor = TextFontColor;
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (void)hideView:(BOOL)isHide{
    if(isHide){
        self.stockBoxView.hidden = YES;
        self.lineView.hidden = YES;
    }else{
        self.stockBoxView.hidden = NO;
        self.lineView.hidden = NO;
    }
}

@end
