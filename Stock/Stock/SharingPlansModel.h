//
//  SharingPlansModel.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharingPlanModel.h"

@interface SharingPlansModel : NSObject

+ (void)getSharingPlansRequest:(NSString*)urlString callback:(void(^)(SharingPlanModel* shareModel))callback;

@end
