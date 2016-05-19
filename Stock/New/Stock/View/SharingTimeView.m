//
//  SharingTimeView.m
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "SharingTimeView.h"
#import "SharingTimeModel.h"
#import "DashLine.h"
#import "CurveLine.h"
#import "VolumnView.h"
#import "TimeHandler.h"

@interface SharingTimeView ()

@property (nonatomic, strong)DashLine* dashLine;
@property (nonatomic, strong)CurveLine* curveLine;
@property (nonatomic, strong)CurveLine* averageCurveLine;
@property (nonatomic, strong)VolumnView* volumnView;
@property (nonatomic, strong)UIView* fiveSpeedView;

@end

@implementation SharingTimeView{
    NSMutableArray* leftLabels;
    NSMutableArray* rightLabels;
    NSMutableArray* timeLabels;
    NSMutableArray* tapeLabels;
    NSMutableArray* tapeContents;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    leftLabels = [NSMutableArray array];
    rightLabels = [NSMutableArray array];
    timeLabels = [NSMutableArray array];
    tapeLabels = [NSMutableArray array];
    tapeContents = [NSMutableArray arrayWithObjects:@"卖5 -- --", @"卖4 -- --", @"卖3 -- --", @"卖2 -- --", @"卖1 -- --", @"买1 -- --", @"买2 -- --", @"买3 -- --", @"买4 -- --", @"买5 -- --", nil];
    
    [self addSubview:self.fiveSpeedView];
    [self addSubview:self.dashLine];
    [self addSubview:self.curveLine];
    [self addSubview:self.averageCurveLine];
    [self addSubview:self.volumnView];
    [self createLabels];
    [self createFiveSpeedView];
    
    [self.curveLine mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.and.left.equalTo(self);
        make.right.equalTo(self.fiveSpeedView.mas_left).offset(-5);
        make.height.mas_equalTo(130);
    }];
    [self.averageCurveLine mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.curveLine);
    }];
    [self.dashLine mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.and.right.and.centerY.equalTo(self.curveLine);
        make.height.mas_equalTo(1);
    }];
    [self.volumnView mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.equalTo(self.curveLine.mas_bottom).offset(15);
        make.left.and.right.equalTo(self.curveLine);
        make.bottom.equalTo(self);
    }];
}

- (void)updateView:(SharingTimeModel*)model{
    CGFloat max = MAX(ABS(model.maxValue - model.yesterdayClosePrice), ABS(model.yesterdayClosePrice - model.minValue));
    if (max == 0) {
        return ;
    }
    CGFloat intervalX = self.curveLine.frame.size.width / [model.currentPriceArray count];
    CGFloat intervalY = self.curveLine.frame.size.height / (2 * max);
    CGFloat x = 0;
    NSMutableArray* currentArray = [NSMutableArray array];
    for (int i = 0; i < model.currentPriceArray.count; i++) {
        CGFloat y = (model.yesterdayClosePrice + max - [model.currentPriceArray[i] floatValue]) * intervalY;
        NSString* point = [NSString stringWithFormat:@"{%.2f,%.2f}", x, y];
        [currentArray addObject:point];
        x += intervalX;
    }
    self.curveLine.points = [currentArray copy];
    
    x = 0;
    [currentArray removeAllObjects];
    for (int i = 0; i < [model.averagePriceArray count]; i++) {
        CGFloat y = (model.yesterdayClosePrice + max - [model.averagePriceArray[i] floatValue]) * intervalY;
        NSString* p = [NSString stringWithFormat:@"{%.2f,%.2f}", x, y];
        [currentArray addObject:p];
        x += intervalX;
    }
    self.averageCurveLine.points = [currentArray copy];
    
    NSInteger num = [leftLabels count];
    CGFloat intervalValue = max / 4;
    for (int i = 0; i < num; i++) {
        UILabel* leftLabel = leftLabels[i];
        UILabel* rightLabel = rightLabels[i];
        UILabel* timeLabel = timeLabels[i];
        if([model.currentPriceArray count] > 0){
            leftLabel.text = [NSString stringWithFormat:@"%.2f", (num / 2 - i) * intervalValue + model.yesterdayClosePrice];
            rightLabel.text = [NSString stringWithFormat:@"%.2f%%", ((num / 2 - i) * intervalValue) / model.yesterdayClosePrice * 100];
            int index = ([model.timesArray count] - 1) * i / (num - 1);
            timeLabel.text = [TimeHandler handleHm:model.timesArray[index]];
        }
    }
    
    x = 0;
    CGFloat y = self.volumnView.frame.size.height;
    CGFloat intervalVolumn = (model.maxVolum - model.minVolum) > 0 ? y / (model.maxVolum - model.minVolum) : 1;
    self.volumnView.lineWidth = self.volumnView.frame.size.width / 242 - 0.5;
    [currentArray removeAllObjects];
    NSMutableArray* colorArray = [NSMutableArray arrayWithObject:[NSNumber numberWithInteger:VOLUMN_VIEW_COLOR_RED]];
    for (int i = 1; i < [model.volumnsArray count]; i++) {
        NSString* startPoint = [NSString stringWithFormat:@"{%.2f,%.2f}", x, y];
        long volumn = [model.volumnsArray[i] floatValue] > 0 ? [model.volumnsArray[i] floatValue] : y;
        NSString* endPoint = [NSString stringWithFormat:@"{%.2f,%.2f}", x, volumn * intervalVolumn];
        NSArray* array = @[startPoint, endPoint];
        [currentArray addObject:array];
        if([model.currentPriceArray[i] floatValue] >= [model.currentPriceArray[i - 1] floatValue]){
            [colorArray addObject:[NSNumber numberWithInteger:VOLUMN_VIEW_COLOR_RED]];
        }else{
            [colorArray addObject:[NSNumber numberWithInteger:VOLUMN_VIEW_COLOR_GREEN]];
        }
        x += self.volumnView.lineWidth + 0.5;
    }
    [self.volumnView drawVolumn:[currentArray copy] colors:[colorArray copy]];
}

- (void)updateTapeView:(NSArray *)tapes{
    for (int i = 0; i < [tapeContents count]; i++) {
        UILabel* label = tapeLabels[i];
        label.text = tapes[i];
        NSInteger loc = [label.text rangeOfString:@" "].location;
        NSInteger backLoc = [label.text rangeOfString:@" " options:NSBackwardsSearch].location;
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attr addAttribute:NSForegroundColorAttributeName value:NavColor range:NSMakeRange(loc, backLoc - loc)];
        label.attributedText = attr;
    }
}

#pragma Private Method

- (void)createLabels{
    for (int i = 0; i < 3; i++) {
        UILabel* leftLabel = [UILabel new];
        leftLabel.textColor = TextGrayColor;
        leftLabel.font = Font(9);
        [self addSubview:leftLabel];
        
        UILabel* rightLabel = [UILabel new];
        rightLabel.textColor = TextGrayColor;
        rightLabel.font = Font(9);
        [self addSubview:rightLabel];
        
        UILabel* timeLabel = [UILabel new];
        timeLabel.textColor = TextGrayColor;
        timeLabel.font = Font(9);
        [self addSubview:timeLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker* make){
            make.left.equalTo(self);
            switch (i) {
                case 0:
                    make.top.equalTo(self.curveLine);
                    break;
                    
                case 1:
                    make.centerY.equalTo(self.curveLine);
                    break;
                    
                case 2:
                    make.bottom.equalTo(self.curveLine);
                    break;
                    
                default:
                    break;
            }
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker* make){
            make.right.equalTo(self.curveLine);
            make.top.equalTo(leftLabel);
        }];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker* make){
            make.top.equalTo(self.curveLine.mas_bottom);
            switch (i) {
                case 0:
                    make.left.equalTo(self.curveLine);
                    break;
                    
                case 1:
                    make.centerX.equalTo(self.curveLine);
                    break;
                    
                case 2:
                    make.right.equalTo(self.curveLine);
                    break;
                    
                default:
                    break;
            }
        }];
        
        [leftLabels addObject:leftLabel];
        [rightLabels addObject:rightLabel];
        [timeLabels addObject:timeLabel];
    }
}

- (void)createFiveSpeedView{
    
    UILabel* fiveSpeedTitleLabel = [UILabel new];
    fiveSpeedTitleLabel.text = @"五档";
    fiveSpeedTitleLabel.textColor = RGB(68, 68, 69);
    fiveSpeedTitleLabel.font = Font(10);
    [self.fiveSpeedView addSubview:fiveSpeedTitleLabel];
    
    [fiveSpeedTitleLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor redColor];
    [self.fiveSpeedView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.equalTo(fiveSpeedTitleLabel.mas_bottom);
        make.left.and.width.equalTo(fiveSpeedTitleLabel);
        make.height.mas_equalTo(1);
    }];
    
    //五档
    UILabel* lastLabel = nil;
    for (int i = 0; i < 10; i++) {
        
        if (i == 5) {
            DashLine* line = [DashLine new];
            [self.fiveSpeedView addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker* make){
                make.left.equalTo(self.fiveSpeedView);
                make.top.equalTo(lastLabel.mas_bottom).offset(5);
                make.height.mas_equalTo(1);
                make.width.equalTo(self.fiveSpeedView);
            }];
        }
        
        UILabel* label = [UILabel new];
        label.text = tapeContents[i];
        label.textColor = TextGrayColor;
        label.font = Font(10);
        [self.fiveSpeedView addSubview:label];
        
        NSInteger loc = [label.text rangeOfString:@" "].location;
        NSInteger backLoc = [label.text rangeOfString:@" " options:NSBackwardsSearch].location;
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attr addAttribute:NSForegroundColorAttributeName value:NavColor range:NSMakeRange(loc, backLoc - loc)];
        label.attributedText = attr;
        
        [label mas_makeConstraints:^(MASConstraintMaker* make){
            make.left.mas_equalTo(5);
            if (lastLabel == nil) {
                make.top.equalTo(line).offset(5);
            }else{
                make.width.equalTo(lastLabel);
                if (i == 5) {
                    make.top.equalTo(lastLabel.mas_bottom).offset(10);
                }else{
                    make.top.equalTo(lastLabel.mas_bottom).offset(5);
                }
            }
        }];
        
        lastLabel = label;
        [tapeLabels addObject:label];
    }
    
    [self.fiveSpeedView mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(lastLabel).offset(LeftSpacing);
        make.height.mas_equalTo(200);
    }];
}

#pragma Getter/Setter

- (DashLine *)dashLine{
    if (_dashLine == nil) {
        _dashLine = [DashLine new];
    }
    return _dashLine;
}

- (CurveLine *)curveLine{
    if (_curveLine == nil) {
        _curveLine = [CurveLine new];
        _curveLine.lineColor = RGB(72, 135, 238);
        _curveLine.isClothPath = YES;
    }
    return _curveLine;
}

- (CurveLine *)averageCurveLine{
    if (_averageCurveLine == nil) {
        _averageCurveLine = [CurveLine new];
        _averageCurveLine.lineColor = RGB(255, 187, 53);
    }
    return _averageCurveLine;
}

- (VolumnView *)volumnView{
    if (_volumnView == nil) {
        _volumnView = [VolumnView new];
    }
    return _volumnView;
}

- (UIView *)fiveSpeedView{
    if (_fiveSpeedView == nil) {
        _fiveSpeedView = [UIView new];
        _fiveSpeedView.backgroundColor = BACKGROUND_COLOR;
    }
    return _fiveSpeedView;
}

@end
