//
//  StockBoxView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/9.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockBoxView.h"

@interface StockBoxView ()

@property (nonatomic, strong)UILabel* timeLabel;

@property (nonatomic, strong)UILabel* currentPriceLabel;

@property (nonatomic, strong)UILabel* ariseLabel;

@property (nonatomic, strong)UILabel* volumnLabel;

@end

@implementation StockBoxView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.timeLabel];
    [self addSubview:self.currentPriceLabel];
    [self addSubview:self.ariseLabel];
    [self addSubview:self.volumnLabel];
}

- (void)updateView:(NSArray*)array{
    self.timeLabel.text = [NSString stringWithFormat:@"时间:%@", array[0]];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"现价:%@", array[1]];
    self.ariseLabel.text = [NSString stringWithFormat:@"涨幅:%@", array[2]];
    self.volumnLabel.text = [NSString stringWithFormat:@"成交量:%@", array[3]];
}

#pragma Private Method

- (UILabel *)timeLabel{
    if(_timeLabel == nil){
        _timeLabel = [self addLabel:CGRectMake(0, 2, self.frame.size.width, 10)];
    }
    return _timeLabel;
}

- (UILabel *)currentPriceLabel{
    if(_currentPriceLabel == nil){
        _currentPriceLabel = [self addLabel:CGRectMake(0, 14, self.frame.size.width, 10)];
    }
    return _currentPriceLabel;
}

- (UILabel *)ariseLabel{
    if(_ariseLabel == nil){
        _ariseLabel = [self addLabel:CGRectMake(0, 26, self.frame.size.width, 10)];
    }
    return _ariseLabel;
}

- (UILabel *)volumnLabel{
    if(_volumnLabel == nil){
        _volumnLabel = [self addLabel:CGRectMake(0, 38, self.frame.size.width, 10)];
    }
    return _volumnLabel;
}

- (UILabel*)addLabel:(CGRect)frame{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.font = Font(8);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
