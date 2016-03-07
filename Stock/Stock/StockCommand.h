//
//  StockCommand.h
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockCommand : NSObject

+ (NSString*)changePriceUnit:(CGFloat)price;

+ (NSString*)changePrice:(CGFloat)price;

@end
