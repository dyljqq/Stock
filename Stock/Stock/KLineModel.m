//
//  KLineModel.m
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "KLineModel.h"

static const int MA5 = 5;
static const int MA10 = 10;
static const int MA20 = 20;

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
    JQQRequest* request = [[JQQRequest alloc] initWithUrlString:urlString];
    request.transmissionFormat = TRANSMISSION_FORMAT_JSON;
    [request callback:^(JQQResponse* response){
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
            if([arr[3] floatValue] > _maxValue)
                self.maxValue = [arr[3] floatValue];
            if([arr[4] floatValue] < _minValue)
                self.minValue = [arr[4] floatValue];
            if([arr[5] unsignedIntegerValue] > _maxVolumeValue)
                self.maxVolumeValue = [arr[5] unsignedIntegerValue];
            if([arr[5] unsignedIntegerValue] < _minVolumeValue)
                self.minVolumeValue = [arr[5] unsignedIntegerValue];
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

@end
