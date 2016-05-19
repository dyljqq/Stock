//
//  StockRecord.h
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockSearchModel.h"

@interface StockRecord : NSObject

+ (NSArray*)getAllStocks;

+ (void)setStock:(StockSearchModel*)stock;

+ (StockSearchModel*)getLastStock;

@end
