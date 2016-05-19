//
//  StrategyRequest.m
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StrategyRequest.h"
#import "StockSearchModel.h"

@implementation StrategyRequest

+ (void)getStockCurrentPrice:(NSArray *)prices complete:(StrategyRequestCompleteBlock)block{
    NSString *str = [prices componentsJoinedByString:@","];
    NSString *urlString = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=%@",str];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject){
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
        NSArray* array = [str componentsSeparatedByString:@"\n"];
        NSMutableArray* priceArray = [NSMutableArray array];
        for (NSString* s in array) {
            NSArray* arr = [s componentsSeparatedByString:@","];
            if (arr.count < 4) {
                [priceArray addObject:@[@"", @""]];
                continue;
            }
            [priceArray addObject:@[arr[2], arr[3]]];
        }
        if (block) {
            block([priceArray copy]);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if (block) {
            block(nil);
        }
        NSLog(@"%@", error);
    }];
}

+ (void)getStockRequest:(NSString *)urlString complete:(StrategyRequestCompleteBlock)block{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject){
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
        NSArray* array = [str componentsSeparatedByString:@"\""];
        NSArray* data = [array count] > 0 ? [array[1] componentsSeparatedByString:@";"] : [NSArray array];
        NSMutableArray* datas = [NSMutableArray array];
        for (NSString* str in data) {
            NSArray* arr = [str componentsSeparatedByString:@","];
            [datas addObject:arr];
        }
        if (block) {
            block([datas copy]);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"%@", error);
    }];
}

@end
