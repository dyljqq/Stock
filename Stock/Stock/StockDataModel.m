//
//  StockDataModel.m
//  DDTG
//
//  Created by 季勤强 on 16/3/14.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockDataModel.h"

@implementation StockDataModel

+ (void)setAllStocks:(NSArray *)array{
    NSArray* arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"allStocks"];
    if(arr == nil){
        arr = [NSArray array];
    }
    NSMutableArray* arrays = [NSMutableArray arrayWithArray:arr];
    __block int flag = 0;
    [arrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if([array isEqualToArray:obj]){
            flag = 1;
        }
    }];
    if(!flag)
        [arrays addObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:[arrays copy] forKey:@"allStocks"];
}

+ (NSArray *)allStocks{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"allStocks"];
}

+ (NSArray *)lastStock{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastStock"];
}

+ (void)removeStock{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"allStocks"];
}

+ (void)setLastStock:(NSArray *)lastItem{
    [[NSUserDefaults standardUserDefaults] setObject:lastItem forKey:@"lastStock"];
}

@end
