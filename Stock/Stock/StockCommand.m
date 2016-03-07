//
//  StockCommand.m
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockCommand.h"

@implementation StockCommand

+ (NSString *)changePriceUnit:(CGFloat)price{
    if(price > 10000){
        price = price / 10000;
    }else if(price > 10000000){
        price = price / 10000000;
    }else if(price > 100000000){
        price = price / 100000000;
    }
    return [NSString stringWithFormat:@"%.0f", price];
}

// 数值变化
+ (NSString*)changePrice:(CGFloat)price{
    CGFloat newPrice = 0;
    NSString *unit = @"万";
    if (price > 10000) {
        newPrice = price / 10000 ;
    }else if (price > 10000000) {
        newPrice = price / 10000000 ;
        unit = @"千万";
    }else if (price > 100000000) {
        newPrice = price / 100000000 ;
        unit = @"亿";
    }
//    NSString *newstr = [[NSString alloc] initWithFormat:@"%.0f%@", newPrice, unit];
    return [NSString stringWithFormat:@"单位：%@", unit];
}

@end
