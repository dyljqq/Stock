//
//  JQQResponse.h
//  AFNetworkingDemo
//
//  Created by 季勤强 on 16/3/11.
//  Copyright © 2016年 季勤强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JQQResponse : NSObject

/**
 *  status code
 */
@property (nonatomic)NSInteger code;

/**
 *  the back infomation message
 */
@property (nonatomic, copy)NSString* message;

/**
 *  the back response data
 */
@property (nonatomic, copy)NSDictionary* data;

@end
