//
//  StockSearchModel.h
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    STOCK_STATUS_NORMAL,
    STOCK_STATUS_DELISTING,
    STOCK_STATUS_SUSPENTION
} STOCK_STATUS;

@interface StockSearchModel : NSObject <NSCoding>

@property (nonatomic, copy)NSString* stockName;
@property (nonatomic, copy)NSString* stockCode;
@property (nonatomic, copy)NSString* stockFullCode;
@property (nonatomic)CGFloat yesterdayPrice;
@property (nonatomic)CGFloat currentPrice;
@property (nonatomic)CGFloat ratio;

@property (nonatomic)STOCK_STATUS status;

@end
