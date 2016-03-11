//
//  StockSearchModel.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockSearchModel : NSObject

+ (void)getStockRequest:(NSString*)urlString callback:(void(^)(NSArray* array))callback;

@end
