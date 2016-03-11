//
//  SKService.h
//  BaseMethodDemo
//
//  Created by 翟玉磊 on 15/11/10.
//  Copyright © 2015年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//把api转化成app接口
//我们从服务器获取api  要转化成接口（域名+api+方式?说明）

@interface SKService : NSObject

/**
 *  接口请求方式（get/post）
 */
@property (nonatomic, strong) NSString *method;

/**
 *  接口请求type(http/json)
 */
@property (nonatomic, strong) NSString *type;
/**
 *  接口URL
 */
@property (nonatomic, strong) NSString *url;

/**
 *  接口说明
 */
@property (nonatomic, strong) NSString *explain;

/**
 *  初始化接口
 *
 *  @param url     url
 *  @param method  请求方式
 *  @param explain 说明
 *
 *  @return 返回接口
 */
-(id)initWithUrl:(NSString *)url andMethod:(NSString *)method andExplain:(NSString *)explain andType:(NSString *)type;

@end
