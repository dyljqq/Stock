//
//  StockSearchCell.m
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchCell.h"
#import "StockSearchModel.h"

#define UP_COLOR RGB(241, 65, 9)
#define DOWN_COLOR RGB(66, 214, 88)

@interface StockSearchCell ()

@property (nonatomic, strong)UILabel* stockNameLabel;
@property (nonatomic, strong)UILabel* stockCodeLabel;
@property (nonatomic, strong)UILabel* currentPriceLabel;
@property (nonatomic, strong)UILabel* ratioLabel;

@end

@implementation StockSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initCell];
    }
    return self;
}

- (void)initCell{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.stockNameLabel];
    [self.contentView addSubview:self.stockCodeLabel];
    [self.contentView addSubview:self.currentPriceLabel];
    [self.contentView addSubview:self.ratioLabel];
    
    [self.stockNameLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(LeftSpacing);
        make.height.mas_equalTo(16);
    }];
    [self.stockCodeLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.equalTo(self.stockNameLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(10);
        make.left.equalTo(self.stockNameLabel);
    }];
    [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(15);
    }];
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerY.equalTo(self);
        make.right.equalTo(self.ratioLabel.mas_left).offset(-13);
        make.height.mas_equalTo(12);
    }];
}

- (void)updateCell:(StockSearchModel*)model{
    self.stockNameLabel.text = model.stockName;
    self.stockCodeLabel.text = model.stockFullCode;
    CGFloat interval = 10;
    if(model.currentPrice == 0){
        self.currentPriceLabel.hidden = YES;
        switch (model.status) {
            case STOCK_STATUS_DELISTING:
                self.ratioLabel.text = @"退市";
                break;
                
            case STOCK_STATUS_SUSPENTION:
                self.ratioLabel.text = @"停牌";
                break;
                
            default:
                break;
        }
        interval = 20;
        self.ratioLabel.backgroundColor = RGB(147, 148, 149);
        self.userInteractionEnabled = NO;
        self.backgroundColor = BACKGROUND_COLOR;
    }else{
        self.currentPriceLabel.text = [NSString stringWithFormat:@"%.2f", model.currentPrice];
        if (model.ratio >= 0) {
            self.ratioLabel.backgroundColor = UP_COLOR;
            self.ratioLabel.text = [NSString stringWithFormat:@"+%.2f%%", model.ratio];
        }else{
            self.ratioLabel.backgroundColor = DOWN_COLOR;
            self.ratioLabel.text = [NSString stringWithFormat:@"%.2f%%", model.ratio];
        }
        self.currentPriceLabel.hidden = NO;
        self.userInteractionEnabled = YES;
    }
    CGFloat width = [HandleString lableWidth:self.ratioLabel.text withSize:CGSizeMake(50, 15) withFont:Font(11)];
    [self.ratioLabel mas_updateConstraints:^(MASConstraintMaker* make){
        make.width.mas_equalTo(width + interval);
    }];
}

#pragma Getter/Setter

- (UILabel *)stockNameLabel{
    if (_stockNameLabel == nil) {
        _stockNameLabel = [UILabel new];
        _stockNameLabel.textColor = TextFontColor;
        _stockNameLabel.font = Font(15);
    }
    return _stockNameLabel;
}

- (UILabel *)stockCodeLabel{
    if (_stockCodeLabel == nil) {
        _stockCodeLabel = [UILabel new];
        _stockCodeLabel.textColor = TextGrayColor;
        _stockCodeLabel.font = Font(9);
    }
    return _stockCodeLabel;
}

- (UILabel *)currentPriceLabel{
    if (_currentPriceLabel == nil) {
        _currentPriceLabel = [UILabel new];
        _currentPriceLabel.textColor = TextGrayColor;
        _currentPriceLabel.font = Font(11);
    }
    return _currentPriceLabel;
}

- (UILabel *)ratioLabel{
    if (_ratioLabel == nil) {
        _ratioLabel = [UILabel new];
        _ratioLabel.textColor = [UIColor whiteColor];
        _ratioLabel.font = Font(11);
        _ratioLabel.backgroundColor = UP_COLOR;
        _ratioLabel.layer.cornerRadius = 3;
        _ratioLabel.layer.masksToBounds = YES;
        _ratioLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ratioLabel;
}

@end
