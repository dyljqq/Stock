//
//  KLineModel.h
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineModel : NSObject

@property (nonatomic, copy)NSString* name;

@property (nonatomic, copy)NSString* symbol;

@property (nonatomic, copy)NSArray* stockArray;

@property (nonatomic, copy)NSArray* maLines; //MA5, MA10, MA20

@property (nonatomic)CGFloat maxValue;

@property (nonatomic)CGFloat minValue;

@property (nonatomic)NSUInteger maxVolumeValue;

@property (nonatomic)NSUInteger minVolumeValue;

@property (nonatomic)CGFloat currentValue;

@property (nonatomic)NSUInteger kCount;

@end
