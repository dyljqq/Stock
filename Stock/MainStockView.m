//
//  MainStockView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "MainStockView.h"
#import "KLineView.h"
#import "UIColor+Helper.h"
#import "HandleString.h"

#define Font(size) [UIFont systemFontOfSize:size]
#define APPLICATION_SIZE [UIScreen mainScreen].bounds.size

@interface MainStockView ()

@property (nonatomic, strong)UIView* headerView;
@property (nonatomic, strong)UILabel* currentPriceLabel;
@property (nonatomic, strong)UIImageView* arrowImageView;
@property (nonatomic, strong)UILabel* riseLabel;
@property (nonatomic, strong)UILabel* increaseLabel;

@property (nonatomic, strong)UIView* backView;

@property (nonatomic, strong)KLineView* kLineView;

@property (nonatomic, strong)UIButton* buyButton;

@property (nonatomic, strong)UILabel* infoLabel;

@end

@implementation MainStockView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    [self.backView addSubview:self.kLineView];
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.currentPriceLabel];
    [self.headerView addSubview:self.arrowImageView];
    [self.headerView addSubview:self.riseLabel];
    [self.headerView addSubview:self.increaseLabel];
    [self addSubview:self.buyButton];
    [self addSubview:self.infoLabel];
}

- (void)updateView:(KLineModel*)model{
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%.2f", model.currentValue];
    CGFloat width = [HandleString lableWidth:self.currentPriceLabel.text withSize:CGSizeMake(100, 36) withFont:Font(35)];
    self.currentPriceLabel.frame = CGRectMake(40, 22.5, width, 36);
    self.arrowImageView.frame = CGRectMake(40 + width + 17, 25.125, 15.5, 27.6);
    self.riseLabel.frame = CGRectMake(self.arrowImageView.frame.origin.x + self.arrowImageView.frame.size.width + 21, 22.5, 100, 12);
    self.increaseLabel.frame = CGRectMake(self.arrowImageView.frame.origin.x + self.arrowImageView.frame.size.width + 21, 44.5, 100, 12);
    
    CGFloat rise = 0;
    if(model.kCount >= 2)
        rise = [model.stockArray[model.kCount - 2][3] floatValue];
    if(model.currentValue - rise > 0){
        self.riseLabel.text = [NSString stringWithFormat:@"+%.2f", model.currentValue - rise];
        self.increaseLabel.text = [NSString stringWithFormat:@"+%.2f%%", (model.currentValue - rise)/model.currentValue * 100];
    }
    else{
        self.riseLabel.text = [NSString stringWithFormat:@"%.2f", model.currentValue - rise];
        self.increaseLabel.text = [NSString stringWithFormat:@"%.2f%%", (model.currentValue - rise)/model.currentValue * 100];
    }
    self.kLineView.kLineModel = model;
    [self.kLineView start];
}

#pragma Private Method

- (UIView *)backView{
    if(_backView == nil){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, APPLICATION_SIZE.width, 265)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (KLineView *)kLineView{
    if(_kLineView == nil){
        _kLineView = [[KLineView alloc] initWithFrame:CGRectMake(5, 44, APPLICATION_SIZE.width - 10, 220)];
        _kLineView.kLineWidth = 5;
        _kLineView.kLinePadding = 0.5;
    }
    return _kLineView;
}

@end
