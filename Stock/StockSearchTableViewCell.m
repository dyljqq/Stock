//
//  StockSearchTableViewCell.m
//  DDTG
//
//  Created by 季勤强 on 16/3/19.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchTableViewCell.h"

@interface StockSearchTableViewCell ()

@property (nonatomic, strong)UILabel* stockNameLabel;
@property (nonatomic, strong)UILabel* stockCodeLabel;

@end

@implementation StockSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.contentView addSubview:self.stockNameLabel];
        [self.contentView addSubview:self.stockCodeLabel];
    }
    return self;
}

- (void)updateCell:(NSString *)stockName stockCode:(NSString *)stockCode{
    self.stockCodeLabel.text = stockCode;
    self.stockNameLabel.text = stockName;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma Private Method

- (UILabel *)stockNameLabel{
    if(_stockNameLabel == nil){
        _stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, APPLICATION_SIZE.width, 16)];
        _stockNameLabel.textColor = TextFontColor;
        _stockNameLabel.font = Font(15);
    }
    return _stockNameLabel;
}

- (UILabel *)stockCodeLabel{
    if(_stockCodeLabel == nil){
        _stockCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, APPLICATION_SIZE.width - 30, 16)];
        _stockCodeLabel.textColor = TextFontColor;
        _stockCodeLabel.font = Font(15);
        _stockCodeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stockCodeLabel;
}
@end
