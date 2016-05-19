//
//  StockRequest.m
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockRequest.h"
#import "SharingTimeModel.h"
#import "KLineModel.h"
#import "KLineStockModel.h"

static const int MA5 = 5;
static const int MA10 = 10;
static const int MA20 = 20;

@implementation StockRequest

+ (void)tapeRequest:(NSString *)urlString callback:(StockRequestBlock)callback{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject){
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
        NSArray* array = [str componentsSeparatedByString:@"\""];
        NSArray* datas = [array count] > 0 ? [array[1] componentsSeparatedByString:@","] : [NSArray array];
        if (callback) {
            callback([datas copy]);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"%@", error);
    }];
}

+ (void)sharingTimeRequest:(NSString *)urlString callback:(StockRequestBlock)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dict = responseObject;
        }else{
            dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
        }
        NSArray* arrays = dict[@"data"];
        SharingTimeModel* model = [SharingTimeModel new];
        model.count = [dict[@"count"] integerValue];
        model.name = dict[@"name"];
        model.symbol = dict[@"symbol"];
        model.yesterdayClosePrice = [dict[@"yestclose"] floatValue];
        
        NSMutableArray* times = [NSMutableArray array];
        NSMutableArray* curPriceArray = [NSMutableArray array];
        NSMutableArray* averagePriceArray = [NSMutableArray array];
        NSMutableArray* volumnsArray = [NSMutableArray array];
        
        CGFloat minValue = CGFLOAT_MAX;
        CGFloat maxValue = CGFLOAT_MIN;
        long maxVolum = LONG_MIN;
        long minVlomun = LONG_MAX;
        for (NSArray* array in arrays) {
            [times addObject:array[0]];
            [curPriceArray addObject:array[1]];
            [averagePriceArray addObject:array[2]];
            [volumnsArray addObject:array[3]];
            if([array[1] floatValue] < minValue)
                minValue = [array[1] floatValue];
            if([array[1] floatValue] > maxValue)
                maxValue = [array[1] floatValue];
            if([array[3] longValue] > maxVolum)
                maxVolum = [array[3] longValue];
            if([array[3] longValue] < minVlomun)
                minVlomun = [array[3] longValue];
        }
        model.minValue = minValue;
        model.maxValue = maxValue;
        model.maxVolum = maxVolum;
        model.minVolum = minVlomun;
        model.timesArray = times;
        model.currentPriceArray = curPriceArray;
        model.volumnsArray = volumnsArray;
        model.averagePriceArray = averagePriceArray;
        if(callback)
            callback(model);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求异常:%@",error);
    }];
}

+ (void)kLineRequest:(NSString *)urlString callback:(StockRequestBlock)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dict = responseObject;
        }else{
            dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
        }
         NSArray* array = dict[@"data"];
         NSMutableArray* items = [NSMutableArray array];
         NSMutableArray* maArrays = [NSMutableArray array];
         NSMutableArray* ma5Array = [NSMutableArray array];
         NSMutableArray* ma10Array = [NSMutableArray array];
         NSMutableArray* ma20Array = [NSMutableArray array];
         int index = 0;
         KLineModel* model = [KLineModel new];
         model.minValue = CGFLOAT_MAX;
         model.minVolumeValue = CGFLOAT_MAX;
         model.kCount = [array count];
         for (NSArray* arr in array) {
             /**
              20160304,时间
              "5.4",收盘价
              "5.37",开盘价
              "5.48",最高价
              "5.12",最低价
              6517543,成交量
              "-0.92"，涨跌幅
              **/
             KLineStockModel* kLineStockmodel = [KLineStockModel new];
             kLineStockmodel.time = [NSString stringWithFormat:@"%@", arr[0]];
             kLineStockmodel.closingPrice = [arr[1] floatValue];
             kLineStockmodel.openPrice = [arr[2] floatValue];
             kLineStockmodel.maxPrice = [arr[3] floatValue];
             kLineStockmodel.minPrice = [arr[4] floatValue];
             kLineStockmodel.volumn = [arr[5] unsignedIntegerValue];
             kLineStockmodel.applies = [arr[6] floatValue];
             if(kLineStockmodel.maxPrice > model.maxValue)
                 model.maxValue = kLineStockmodel.maxPrice;
             if(kLineStockmodel.minPrice < model.minValue)
                 model.minValue = kLineStockmodel.minPrice;
             if(kLineStockmodel.volumn > model.maxVolumeValue)
                 model.maxVolumeValue = kLineStockmodel.volumn;
             if(kLineStockmodel.volumn < model.minVolumeValue)
                 model.minVolumeValue = kLineStockmodel.volumn;
             
             if(index >= 5){
                 [ma5Array addObject:[self priceBeforeNum:[array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index - MA5, MA5)]]]];
             }else{
                 [ma5Array addObject:[NSNumber numberWithFloat:0.0]];
             }
             if(index >= 10){
                 [ma10Array addObject:[self priceBeforeNum:[array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index - MA10, MA10)]]]];
             }else{
                 [ma10Array addObject:[NSNumber numberWithFloat:0.0]];
             }
             if(index >= 20){
                 [ma20Array addObject:[self priceBeforeNum:[array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index - MA20, MA20)]]]];
             }else{
                 [ma20Array addObject:[NSNumber numberWithFloat:0.0]];
             }
             
             [items addObject:kLineStockmodel];
             index++;
         }
         [maArrays addObject:[ma5Array copy]];
         [maArrays addObject:[ma10Array copy]];
         [maArrays addObject:[ma20Array copy]];
         model.currentValue = [array count] > 0 ? [array[model.kCount - 1][2] floatValue] : 0;
         model.stockArray = [items copy];
         model.maLines = [maArrays copy];
         model.name = dict[@"name"];
         model.symbol = dict[@"symbol"];
         if (callback) {
             callback(model);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"请求异常:%@",error);
     }];
}

+ (NSNumber*)priceBeforeNum:(NSArray*)array{
    CGFloat sum = 0.0;
    for (int i = 0; i < [array count]; i++) {
        sum += [[array[i] objectAtIndex:4] floatValue];
    }
    return [NSNumber numberWithFloat:sum/[array count]];
}

@end
