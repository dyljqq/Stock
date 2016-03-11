//
//  JQQRequest.h
//  AFNetworkingDemo
//
//  Created by 季勤强 on 16/3/11.
//  Copyright © 2016年 季勤强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQQResponse.h"

typedef enum : NSUInteger {
    TRANSMISSION_FORMAT_HTTP,
    TRANSMISSION_FORMAT_JSON,
    TRANSMISSION_FORMAT_XML
} TRANSMISSION_FORMAT;

typedef enum : NSUInteger {
    REQUEST_TYPE_GET,
    REQUEST_TYPE_POST,
} REQUEST_TYPE;

typedef void (^JQQRequestCallbackBlock)(JQQResponse* response);

@interface JQQRequest : NSObject

//get or post, insensitive capital, default is get
@property (nonatomic)REQUEST_TYPE requestType;

//http, json, xml or other, default is http
@property (nonatomic)TRANSMISSION_FORMAT transmissionFormat;

/**
 *  initial method
 *
 *  @param urlString url
 *
 *  @return self
 */
- (instancetype)initWithUrlString:(NSString*)urlString;

/**
 *  param
 *
 *  @param param value
 *  @param key   key
 */
- (void)setParam:(id)param key:(NSString*)key;

/**
 *  request method
 *
 *  @param callback callback data
 */
- (void)callback:(JQQRequestCallbackBlock)callback;

/**
 *  download task
 *
 *  @param urlString url
 *  @param callback  callback
 */
+ (void)downloadTask:(NSString*)urlString callback:(JQQRequestCallbackBlock)callback;

/**
 *  upload task, like upload image and so on;
 *
 *  @param urlString      url name
 *  @param filePathString file's path
 *  @param callback       callback
 */
+ (void)uploadTask:(NSString*)urlString filePath:(NSString*)filePathString callback:(JQQRequestCallbackBlock)callback;

/**
 *  upload form data
 *
 *  @param urlString      url name
 *  @param filePathString file's path
 *  @param callback       callback
 */
+ (void)uploadFormTask:(NSString*)urlString filePath:(NSString*)filePathString callback:(JQQRequestCallbackBlock)callback;

@end
