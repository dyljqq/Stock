//
//  StockRecord.m
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockRecord.h"

static NSString* STOCK_HISTORY = @"STOCK_HISTORY";

@implementation StockRecord

+ (NSArray *)getAllStocks{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:STOCK_HISTORY];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (array == nil) {
        array = [NSArray array];
    }
    return array.count > 5 ? [array subarrayWithRange:NSMakeRange(0, 5)] : array;
}

+ (void)setStock:(StockSearchModel *)stock{
    NSData* datas = [[NSUserDefaults standardUserDefaults] objectForKey:STOCK_HISTORY];
    NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:datas];
    if (arr == nil) {
        arr = [NSArray array];
    }
    NSMutableArray* array = [NSMutableArray arrayWithArray:arr];
    for (StockSearchModel* model in array) {
        if([model isEqual:stock]){
            return ;
        }
    }
    [array insertObject:stock atIndex:0];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:STOCK_HISTORY];
}

+ (StockSearchModel *)getLastStock{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:STOCK_HISTORY];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [array count] > 0 ? array[0] : [NSArray array];
}

@end
