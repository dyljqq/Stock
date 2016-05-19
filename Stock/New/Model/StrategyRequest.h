//
//  StrategyRequest.h
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StrategyRequestCompleteBlock)(NSArray* array);

@interface StrategyRequest : NSObject

/**
 *  获取股票现价
 *
 *  @param prices 需要获取的股票数组,里面是股票代码
 */
+ (void)getStockCurrentPrice:(NSArray*)prices complete:(StrategyRequestCompleteBlock)block;

/**
 *  获取股票信息
 *
 *  @param urlString 股票地址
 *  @param block     返回符合的股票信息
 */
+ (void)getStockRequest:(NSString*)urlString complete:(StrategyRequestCompleteBlock)block;

@end
