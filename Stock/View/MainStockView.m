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
#import "StockScrollView.h"
#import "HandicapView.h"
#import "SharingPlansView.h"
#import "KLinesView.h"

@interface MainStockView ()

@property (nonatomic, strong)UIView* headerView;
@property (nonatomic, strong)UILabel* currentPriceLabel;
@property (nonatomic, strong)UIImageView* arrowImageView;
@property (nonatomic, strong)UILabel* riseLabel;
@property (nonatomic, strong)UILabel* increaseLabel;

@property (nonatomic, strong)UIView* backView;

@property (nonatomic, strong)StockScrollView* stockScrollView;

@property (nonatomic, strong)KLineView* kLineView;
@property (nonatomic, strong)KLinesView* kLinesView;

@property (nonatomic, strong)HandicapView* handicapView;

@property (nonatomic, strong)SharingPlansView* sharingPlansView;

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
    self.backgroundColor = BACKGROUND_COLOR;
    
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.currentPriceLabel];
    [self.headerView addSubview:self.arrowImageView];
    [self.headerView addSubview:self.riseLabel];
    [self.headerView addSubview:self.increaseLabel];
    
    [self addSubview:self.stockScrollView];
    self.stockScrollView.frame = CGRectMake(0, 80, APPLICATION_SIZE.width, 265);
    
    NSArray* array = @[self.sharingPlansView, self.kLinesView, self.handicapView];
    [self.stockScrollView initView:array];
    
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
    }else{
        self.riseLabel.text = [NSString stringWithFormat:@"%.2f", model.currentValue - rise];
        self.increaseLabel.text = [NSString stringWithFormat:@"%.2f%%", (model.currentValue - rise)/model.currentValue * 100];
    }
    [self updatehead:model.currentValue - rise > 0];
    [self.kLinesView updateView:model];
}

- (void)updateStockView:(NSArray*)contents colors:(NSArray*)colors{
    [self.handicapView updateView:contents textColors:colors];
}

- (void)updateSharingPlansView:(id)model{    
    [self.sharingPlansView updateView:model];
}

- (void)updatehead:(BOOL)isRed{
    if(isRed){
        self.headerView.backgroundColor = NavColor;
        self.arrowImageView.image = [UIImage imageNamed:@"iconfont_jt"];
    }else{
        self.headerView.backgroundColor = RGB(76, 209, 207);
        self.arrowImageView.image = [UIImage imageNamed:@"iconfont_jtx"];
    }
}

#pragma Action

- (void)buyAction{
    //TODO
    [self.delegate buy];
}

#pragma Private Method

- (KLineView *)kLineView{
    if(_kLineView == nil){
        _kLineView = [[KLineView alloc] initWithFrame:CGRectMake(5, 10, APPLICATION_SIZE.width - 10, 220)];
        _kLineView.kLineWidth = 5;
        _kLineView.kLinePadding = 0.5;
    }
    return _kLineView;
}

- (UIView *)headerView{
    if(_headerView == nil){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SIZE.width, 80)];
        _headerView.backgroundColor = NavColor;
    }
    return _headerView;
}

- (UILabel *)currentPriceLabel{
    if(_currentPriceLabel == nil){
        _currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 22.5, 100, 36)];
        _currentPriceLabel.textColor = [UIColor whiteColor];
        _currentPriceLabel.font = Font(35);
    }
    return _currentPriceLabel;
}

- (UIImageView *)arrowImageView{
    if(_arrowImageView == nil){
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"iconfont_jt"];
    }
    return _arrowImageView;
}

- (UILabel *)riseLabel{
    if(_riseLabel == nil){
        _riseLabel = [UILabel new];
        _riseLabel.textColor = [UIColor whiteColor];
        _riseLabel.font = Font(11);
    }
    return _riseLabel;
}

- (UILabel *)increaseLabel{
    if(_increaseLabel == nil){
        _increaseLabel = [UILabel new];
        _increaseLabel.textColor = [UIColor whiteColor];
        _increaseLabel.font = Font(11);
    }
    return _increaseLabel;
}

- (StockScrollView *)stockScrollView{
    if(_stockScrollView == nil){
        _stockScrollView = [StockScrollView new];
    }
    return _stockScrollView;
}

- (HandicapView *)handicapView{
    if(_handicapView == nil){
        _handicapView = [[HandicapView alloc] initWithFrame:CGRectMake(5, 10, APPLICATION_SIZE.width - 10, self.stockScrollView.frame.size.height - 45)];
    }
    return _handicapView;
}

- (SharingPlansView *)sharingPlansView{
    if(_sharingPlansView == nil){
        _sharingPlansView = [[SharingPlansView alloc] initWithFrame:CGRectMake(5, 10, APPLICATION_SIZE.width - 10, self.stockScrollView.frame.size.height - 45)];
    }
    return _sharingPlansView;
}

- (UIButton *)buyButton{
    if(_buyButton == nil){
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 49 - 32 - 64, APPLICATION_SIZE.width - 30, 45)];
        _buyButton.backgroundColor = RGB(253, 191, 45);
        [_buyButton setTitle:@"买入" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyButton.layer.cornerRadius = 3;
        _buyButton.layer.masksToBounds = YES;
        [_buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

- (UILabel *)infoLabel{
    if(_infoLabel == nil){
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.buyButton.frame.origin.y + 50, APPLICATION_SIZE.width, 12)];
        _infoLabel.text = @"当前非交易时间， 交易时间段：09:30-15:00(交易日)";
        _infoLabel.textColor = TextGrayColor;
        _infoLabel.font = Font(11);
    }
    return _infoLabel;
}

- (KLinesView *)kLinesView{
    if(_kLinesView == nil){
        _kLinesView = [[KLinesView alloc] initWithFrame:CGRectMake(5, 10, APPLICATION_SIZE.width - 10, 220)];
    }
    return _kLinesView;
}

@end
