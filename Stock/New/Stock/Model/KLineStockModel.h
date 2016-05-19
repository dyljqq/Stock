//
//  KLineStockModel.h
//  DDTG
//
//  Created by 季勤强 on 16/5/16.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineStockModel : NSObject

@property (nonatomic)CGFloat maxPrice;
@property (nonatomic)CGFloat minPrice;
@property (nonatomic)CGFloat closingPrice;
@property (nonatomic)CGFloat openPrice;
@property (nonatomic)NSUInteger volumn;
@property (nonatomic)CGFloat applies;

@property (nonatomic, copy)NSString* time;

@end
