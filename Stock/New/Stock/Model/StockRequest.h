//
//  StockRequest.h
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StockRequestBlock)(id object);

@interface StockRequest : NSObject

/**
 *  获取盘口信息
 *
 *  @param urlString 盘口地址
 *  @param callback  回调
 */
+ (void)tapeRequest:(NSString*)urlString callback:(StockRequestBlock)callback;

/**
 *  获取分时图信息
 *
 *  @param urlString 分时图请求地址
 *  @param callback  回调
 */
+ (void)sharingTimeRequest:(NSString*)urlString callback:(StockRequestBlock)callback;

/**
 *  获取k线信息
 *
 *  @param urlString k线请求地址
 *  @param callback  回调
 */
+ (void)kLineRequest:(NSString*)urlString callback:(StockRequestBlock)callback;

@end
