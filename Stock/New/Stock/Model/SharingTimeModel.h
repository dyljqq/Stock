//
//  SharingTimeModel.h
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharingTimeModel : NSObject

@property (nonatomic, copy)NSArray* averagePriceArray;

@property (nonatomic, copy)NSArray* currentPriceArray;

@property (nonatomic, copy)NSArray* volumnsArray;

@property (nonatomic, copy)NSArray* timesArray;

@property (nonatomic)CGFloat yesterdayClosePrice;

@property (nonatomic)CGFloat minValue;

@property (nonatomic)CGFloat maxValue;

@property (nonatomic)CGFloat maxVolum;

@property (nonatomic)CGFloat minVolum;

@property (nonatomic, copy)NSString* name;

@property (nonatomic, copy)NSString* symbol;

@property (nonatomic)NSInteger count;

@end
