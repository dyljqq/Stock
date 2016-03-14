//
//  StockDataModel.h
//  DDTG
//
//  Created by 季勤强 on 16/3/14.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockDataModel : NSObject

+ (NSArray*)allStocks;

+ (void)setAllStocks:(NSArray*)array;

+ (NSArray*)lastStock;

+ (void)setLastStock:(NSArray*)lastItem;

+ (void)removeStock;

@end
