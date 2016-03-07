//
//  SKResponse.h
//  BaseMethodDemo
//
//  Created by 翟玉磊 on 15/11/10.
//  Copyright © 2015年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKResponse : NSObject

/**
 *  请求结果代码code值
 */
@property (nonatomic) int code;

/**
 *  结果数据
 */
@property (nonatomic, strong) NSDictionary *data;

/**
 *  结果说明
 */
@property (nonatomic, strong) NSString *message;
@end
