//
//  TimeHandler.h
//  DDTG
//
//  Created by 季勤强 on 16/5/16.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHandler : NSObject

//处理诸如“0930”的时间数据
+ (NSString*)handleHm:(NSString*)time;

//处理诸如“20160516”
+ (NSString*)handleYm:(NSString*)date;

@end
