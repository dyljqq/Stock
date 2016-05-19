//
//  KLineView.m
//  DDTG
//
//  Created by 季勤强 on 16/5/16.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "KLineView.h"
#import "KLine.h"
#import "KLineModel.h"
#import "KLineStockModel.h"
#import "VolumnView.h"
#import "TimeHandler.h"
#import "CurveLine.h"
#import "HandleMethod.h"

@interface KLineView ()

@property (nonatomic, strong)KLine* kLine;
@property (nonatomic, strong)VolumnView* volumnView;
@property (nonatomic, strong)UILabel* volumnLabel;
@property (nonatomic, strong)UILabel* volumnNumLabel;

@end

@implementation KLineView{
    CGFloat lineWidth;
    CGFloat linePadding;
    NSMutableArray* timeLabels;
    NSMutableArray* valueLabels;
    NSMutableArray* curveLines;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor clearColor];
    
    lineWidth = 5.0;
    linePadding = 2.0;
    timeLabels = [NSMutableArray array];
    valueLabels = [NSMutableArray array];
    curveLines = [NSMutableArray array];
    
    [self addSubview:self.kLine];
    [self addSubview:self.volumnView];
    [self.volumnView addSubview:self.volumnLabel];
    [self.volumnView addSubview:self.volumnNumLabel];
    [self createLabel];
    [self createCurveLine];
    
    [self.kLine mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.and.left.and.right.equalTo(self);
        make.bottom.equalTo(self).multipliedBy(0.75);
    }];
    [self.volumnView mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.and.right.and.bottom.equalTo(self);
        make.top.equalTo(self.kLine.mas_bottom).offset(15);
    }];
    [self.volumnLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.and.left.equalTo(self.volumnView);
    }];
    [self.volumnNumLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.right.and.top.equalTo(self.volumnView);
    }];
}

- (void)updateView:(KLineModel*)kLineModel{
    NSInteger num = [self kLineNum];
    NSInteger count = kLineModel.stockArray.count;
    if (count == 0) {
        return ;
    }
    self.volumnLabel.text = @"成交量";
    
    NSMutableArray* points = [NSMutableArray array];
    NSMutableArray* colors = [NSMutableArray array];
    NSMutableArray* volumnPoints = [NSMutableArray array];
    NSMutableArray* ma5Points = [NSMutableArray array];
    NSMutableArray* ma10Points = [NSMutableArray array];
    NSMutableArray* ma20Points = [NSMutableArray array];
    CGFloat x = 0;
    if (num > count) {
        count = num;
        num = 0;
    }
    for (int i = count - num; i < count; i++) {
        CGFloat height = self.kLine.frame.size.height;
        NSMutableArray* point = [NSMutableArray array];
        
        KLineStockModel* model = kLineModel.stockArray[i];
        CGFloat rate = height / (kLineModel.maxValue - kLineModel.minValue);
        CGFloat y = (kLineModel.maxValue - model.maxPrice) * rate;
        [point addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x, y]];
        CGFloat y1 = 0, y2 = 0;
        if (model.closingPrice > model.openPrice) {
            y1 = (kLineModel.maxValue - model.closingPrice) * rate;
            y2 = (kLineModel.maxValue - model.openPrice) * rate;
            [colors addObject:[NSNumber numberWithInteger:KLINE_COLOR_RED]];
        }else{
            y1 = (kLineModel.maxValue - model.openPrice) * rate;
            y2 = (kLineModel.maxValue - model.closingPrice) * rate;
            [colors addObject:[NSNumber numberWithInteger:KLINE_COLOR_GREEN]];
        }
        [point addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x, y1]];
        [point addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x - lineWidth / 2, y1]];
        [point addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x + lineWidth / 2, y1]];
        [point addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x + lineWidth / 2, y2]];
        [point addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x - lineWidth / 2, y2]];
        [point addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x, y2]];
        y = (kLineModel.maxValue - model.minPrice) * rate;
        [point addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x, y]];
        [points addObject:[point copy]];
        
        //计算ma值
        [ma5Points addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x, (kLineModel.maxValue - [kLineModel.maLines[0][i] floatValue]) * rate]];
        [ma10Points addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x, (kLineModel.maxValue - [kLineModel.maLines[1][i] floatValue]) * rate]];
        [ma20Points addObject:[NSString stringWithFormat:@"{%.2f,%.2f}", x, (kLineModel.maxValue - [kLineModel.maLines[2][i] floatValue]) * rate]];
        
        //计算成交量
        rate = self.volumnView.frame.size.height / (kLineModel.maxVolumeValue - kLineModel.minVolumeValue);
        rate = rate > 0 ? rate : 0.0;
        y = (kLineModel.maxVolumeValue - model.volumn) * rate;
        [volumnPoints addObject:@[[NSString stringWithFormat:@"{%.2f,%.2f}", x, self.volumnView.frame.size.height], [NSString stringWithFormat:@"{%.2f,%.2f}", x, y]]];
        
        x += lineWidth + linePadding;
    }
    [self.kLine drawKline:[points copy] colors:[colors copy]];
    [self.volumnView drawVolumn:[volumnPoints copy] colors:[colors copy]];
    
    for (int i = 0; i < [timeLabels count]; i++) {
        UILabel* timeLabel = timeLabels[i];
        UILabel* valueLabel = valueLabels[i];
        
        NSInteger index = num + i * (count - num) / 2 - 1;
        KLineStockModel* model = kLineModel.stockArray[index];
        timeLabel.text = [TimeHandler handleYm:model.time];
        valueLabel.text = [NSString stringWithFormat:@"%.2f", kLineModel.maxValue - i * (kLineModel.maxValue - kLineModel.minValue) / 2];
    }
    
    NSArray* maPoints = @[[ma5Points copy], [ma10Points copy], [ma20Points copy]];
    for (int i = 0; i < [curveLines count]; i++) {
        CurveLine* line = curveLines[i];
        line.points = maPoints[i];
    }
    
    self.volumnNumLabel.text = [HandleMethod handleTapeData:kLineModel.maxVolumeValue];
}

#pragma Private Method

- (void)createLabel{
    for (int i = 0; i < 3; i++) {
        UILabel* timeLabel = [UILabel new];
        timeLabel.textColor = TextGrayColor;
        timeLabel.font = Font(9);
        [self addSubview:timeLabel];
        
        UILabel* valueLabel = [UILabel new];
        valueLabel.textColor = TextGrayColor;
        valueLabel.font = Font(9);
        [self addSubview:valueLabel];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker* make){
            make.top.equalTo(self.kLine.mas_bottom);
            switch (i) {
                case 0:
                    make.left.equalTo(self);
                    break;
                    
                case 1:
                    make.centerX.equalTo(self);
                    break;
                    
                case 2:
                    make.right.equalTo(self);
                    break;
                    
                default:
                    break;
            }
        }];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker* make){
            make.right.equalTo(self);
            switch (i) {
                case 0:
                    make.top.equalTo(self.kLine);
                    break;
                    
                case 1:
                    make.centerY.equalTo(self.kLine);
                    break;
                    
                case 2:
                    make.bottom.equalTo(self.kLine);
                    break;
                    
                default:
                    break;
            }
        }];
        
        [timeLabels addObject:timeLabel];
        [valueLabels addObject:valueLabel];
    }
}

- (void)createCurveLine{
    for (int i = 0; i < 3; i++) {
        CurveLine* line = [CurveLine new];
        switch (i) {
            case 0:
                line.lineColor = RGB(255, 187, 53);
                break;
                
            case 1:
                line.lineColor = RGB(50, 130, 228);
                break;
                
            case 2:
                line.lineColor = RGB(196, 36, 250);
                break;
                
            default:
                break;
        }
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker* make){
            make.edges.equalTo(self.kLine);
        }];
        
        [curveLines addObject:line];
    }
}

- (NSInteger)kLineNum{
    return self.frame.size.width / (lineWidth + linePadding);
}

#pragma Getter/Setter

- (KLine *)kLine{
    if (_kLine == nil) {
        _kLine = [KLine new];
        _kLine.layer.borderColor = LINE_COLOR.CGColor;
        _kLine.layer.borderWidth = 0.5;
    }
    return _kLine;
}

- (VolumnView *)volumnView{
    if (_volumnView == nil) {
        _volumnView = [VolumnView new];
        _volumnView.lineWidth = lineWidth;
        _volumnView.layer.borderColor = LINE_COLOR.CGColor;
        _volumnView.layer.borderWidth = 0.5;
    }
    return _volumnView;
}

- (UILabel *)volumnLabel{
    if (_volumnLabel == nil) {
        _volumnLabel = [UILabel new];
        _volumnLabel.textColor = TextGrayColor;
        _volumnLabel.font = Font(9);
    }
    return _volumnLabel;
}

- (UILabel *)volumnNumLabel{
    if (_volumnNumLabel == nil) {
        _volumnNumLabel = [UILabel new];
        _volumnNumLabel.textColor = TextGrayColor;
        _volumnNumLabel.font = Font(9);
    }
    return _volumnNumLabel;
}

@end
