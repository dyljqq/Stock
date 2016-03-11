//
//  MoveKLineView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/9.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "MoveKLineView.h"

@interface MoveKLineView ()

@property (nonatomic, strong)UILabel* priceLabel;

@property (nonatomic, strong)UILabel* timeLabel;

@property (nonatomic, strong)UIView* verticalLine;

@property (nonatomic, strong)UIView* horizontalLine;

@end

@implementation MoveKLineView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self addSubview:self.priceLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.verticalLine];
    [self addSubview:self.horizontalLine];
}

- (void)updateView:(CGPoint)point stockPrice:(NSString*)price time:(NSString*)time{
    self.priceLabel.text = price;
    self.timeLabel.text = time;
    float width = [HandleString lableWidth:price withSize:CGSizeMake(50, 10) withFont:Font(9)];
    self.timeLabel.frame = CGRectMake(point.x, self.frame.size.height - 10, width, 10);
    width = [HandleString lableWidth:price withSize:CGSizeMake(50, 10) withFont:Font(9)];
    if(point.x > self.frame.size.width/2){
        self.priceLabel.frame = CGRectMake(0, point.y, width + 10, 10);
    }else{
        self.priceLabel.frame = CGRectMake(self.frame.size.width + self.frame.origin.x - width, point.y, width + 10, 10);
    }
    self.verticalLine.frame = CGRectMake(point.x, 0, 0.5, self.frame.size.height - 10);
    self.horizontalLine.frame = CGRectMake(0, point.y, self.frame.size.width, 0.5);
}

#pragma Private Method

- (UILabel *)priceLabel{
    if(_priceLabel == nil){
        _priceLabel = [UILabel new];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.font = Font(9);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (UILabel *)timeLabel{
    if(_timeLabel == nil){
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = Font(9);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIView *)verticalLine{
    if(_verticalLine == nil){
        _verticalLine = [UIView new];
        _verticalLine.backgroundColor = TextFontColor;
    }
    return _verticalLine;
}

- (UIView *)horizontalLine{
    if(_horizontalLine == nil){
        _horizontalLine = [UIView new];
        _horizontalLine.backgroundColor = TextFontColor;
    }
    return _horizontalLine;
}

@end
