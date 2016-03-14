//
//  SharingPlansModel.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//

#import "SharingPlansModel.h"

@implementation SharingPlansModel

+ (void)getSharingPlansRequest:(NSString *)urlString callback:(void (^)(SharingPlanModel* shareModel))callback{
    JQQRequest* request = [[JQQRequest alloc] initWithUrlString:urlString];
    request.transmissionFormat = TRANSMISSION_FORMAT_JSON;
    [request callback:^(JQQResponse* response){
        NSArray* arrays = response.data[@"data"];
        SharingPlanModel* model = [SharingPlanModel new];
        model.count = [response.data[@"count"] integerValue];
        model.name = response.data[@"name"];
        model.symbol = response.data[@"symbol"];
        model.yesterdayClosePrice = [response.data[@"yestclose"] floatValue];
        
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
    }];
}

@end
