//
//  StockSearchModel.m
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchModel.h"

@implementation StockSearchModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self =[super init];
    if(self){
        self.stockName = [aDecoder decodeObjectForKey:@"stockName"];
        self.stockCode = [aDecoder decodeObjectForKey:@"stockCode"];
        self.stockFullCode = [aDecoder decodeObjectForKey:@"stockFullCode"];
        self.currentPrice = [[aDecoder decodeObjectForKey:@"currentPrice"] floatValue];
        self.yesterdayPrice = [[aDecoder decodeObjectForKey:@"yesterdayPrice"] floatValue];
        self.ratio = [[aDecoder decodeObjectForKey:@"ratio"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.stockName forKey:@"stockName"];
    [aCoder encodeObject:self.stockCode forKey:@"stockCode"];
    [aCoder encodeObject:self.stockFullCode forKey:@"stockFullCode"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.currentPrice] forKey:@"currentPrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.yesterdayPrice] forKey:@"yesterdayPrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.ratio] forKey:@"ratio"];
}

@end
