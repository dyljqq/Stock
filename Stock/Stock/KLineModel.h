//
//  KLineModel.h
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 data, name, symbol
 **/

typedef void (^KLineModelBlock)();

@interface KLineModel : NSObject

@property (nonatomic, copy)NSString* name;

@property (nonatomic, copy)NSString* symbol;

@property (nonatomic, copy)NSArray* stockArray;

@property (nonatomic, copy)NSArray* timeArray;

@property (nonatomic)CGFloat maxValue;

@property (nonatomic)CGFloat minValue;

@property (nonatomic)NSUInteger maxVolumeValue;

@property (nonatomic)NSUInteger minVolumeValue;

@property (nonatomic)CGFloat currentValue;

@property (nonatomic)NSUInteger kCount;

- (void)getKLineRequest:(NSString*)urlString callback:(KLineModelBlock)callback;

@end
