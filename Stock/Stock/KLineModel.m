//
//  KLineModel.m
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "KLineModel.h"
#import <AFNetworking/AFNetworking.h>
#import "SKResponse.h"

static const int MA5 = 5;
static const int MA10 = 10;
static const int MA20 = 20;

@interface KLineModel ()

@end

@implementation KLineModel

- (instancetype)init{
    self = [super init];
    if(self){
        _minValue = CGFLOAT_MAX;
        _minVolumeValue = CGFLOAT_MAX;
    }
    return self;
}

- (void)getKLineRequest:(NSString *)urlString callback:(KLineModelBlock)callback{
    [self getData:urlString callback:^(SKResponse* response){
        NSArray* array = response.data[@"data"];
        NSMutableArray* items = [NSMutableArray array];
        NSMutableArray* times = [NSMutableArray array];
        int index = 0;
        _kCount = [array count];
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
            NSMutableArray* item = [NSMutableArray array];
            if([arr[1] floatValue] > _maxValue)
                _maxValue = [arr[1] floatValue];
            if([arr[2] floatValue] < _minValue)
                _minValue = [arr[2] floatValue];
            if([arr[5] unsignedIntegerValue] > _maxVolumeValue)
                _maxVolumeValue = [arr[5] unsignedIntegerValue];
            if([arr[5] unsignedIntegerValue] < _minVolumeValue)
                _minVolumeValue = [arr[5] unsignedIntegerValue];
            [times addObject:arr[0]];
            [item addObject:arr[1]];
            [item addObject:arr[3]];
            [item addObject:arr[4]];
            [item addObject:arr[2]];
            [item addObject:arr[5]];
            if(index >= 5){
                [item addObject:[self priceBeforeNum:[array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index - MA5, MA5)]]]];
            }else{
                [item addObject:[NSNumber numberWithFloat:0.0]];
            }
            if(index >= 10){
                [item addObject:[self priceBeforeNum:[array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index - MA10, MA10)]]]];
            }else{
                [item addObject:[NSNumber numberWithFloat:0.0]];
            }
            if(index >= 20){
                [item addObject:[self priceBeforeNum:[array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index - MA20, MA20)]]]];
            }else{
                [item addObject:[NSNumber numberWithFloat:0.0]];
            }
            [items addObject:item];
            index++;
        }
        _currentValue = [array count] > 0 ? [array[_kCount - 1][2] floatValue] : 0;
        self.stockArray = [items copy];
        self.timeArray = [times copy];
        self.name = response.data[@"name"];
        self.symbol = response.data[@"symbol"];
        if(callback)
            callback();
    }];
}

- (NSNumber*)priceBeforeNum:(NSArray*)array{
    CGFloat sum = 0.0;
    for (int i = 0; i < [array count]; i++) {
        sum += [[array[i] objectAtIndex:4] floatValue];
    }
    return [NSNumber numberWithFloat:sum/[array count]];
}

- (void)getData:(NSString*)url callback:(void(^)(SKResponse* response))callback{
    
     AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"Response Data:%@",responseObject);
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingMutableLeaves error:&error];
        // 字典转模型
        SKResponse *response = [[SKResponse alloc] init];
        response.data = dict;
        if (callback) {
            callback(response);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        // 请求异常
        NSLog(@"请求异常：%@",error);
    }];
}

@end
