//
//  BaseMethod.h
//  BaseMethodDemo
//
//  Created by 翟玉磊 on 15/11/5.
//  Copyright © 2015年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//app中的一些基础方法
@interface BaseMethod : NSObject

/**
 *  判断字符串是否为空
 *
 *  @param object 要判断的字符串
 *
 *  @return 返回YES不为空  NO为空
 */
+(BOOL)isNOTNull:(id)object;

/**
 *  把参数转成字符串 （避免取数据产生数据类型崩溃）
 *
 *  @param id 参数
 *
 *  @return 返回字符串 （参数如果不是字符串和NSNumber会返回空字符串）
 */
+ (NSString *)toString :(id)id;

/**
 *  md5加密
 *
 *  @param string 要加密的字符串
 *
 *  @return 返回md5字符串（32位）
 */
+ (NSString *)getMd5WithString:(NSString *)string;

/**
 *  获取图片URL
 *
 *  @param string 图片地址
 *
 *  @return 返回图片URL
 */
+ (NSURL *)getImageURLWith:(NSString *)string;

/**
 *  获取指定宽度的图片URL（根据upyunSDK使用）
 *
 *  @param string 图片地址（网络地址）
 *  @param string 需要的是说明图片（smallIcon、appIcon、宽度数字） ….jpg!200
 *
 *  @return 返回URL
 */
+ (NSURL *)getImageURLWith:(NSString *)string need:(NSString *)need;

/**
 *  获取语音URl
 *
 *  @param string 语音地址 （网络地址）
 *
 *  @return 返回完整的URL地址
 */
+ (NSURL *)getVoiceURLWith:(NSString *)string;

//***********************下面是文件操作***********************//

/**
 *  data存储到本地
 *
 *  @param path 本地路径：沙盒/path
 *  @param data 要存储的数据
 */
+ (void)saveDataPath:(NSString *)path withData:(NSData *)data;

/**
 *  删除指定路径的文件
 *
 *  @param path 要删除的文件路径
 */
+ (void)removeFile:(NSString *)path;

/**
 *  根据本地路径获取图片
 *
 *  @param path 文件路径
 *
 *  @return 返回图片
 */
+ (UIImage *)getImageWithFilePath:(NSString *)path;

/**
 *  根据本地路径获取data（语音，视频）
 *
 *  @param path 文件路径
 *
 *  @return 返回数据
 */
+ (NSData *)getDataWithFilePath:(NSString *)path;

/**
 *  由颜色值生成的图片
 *
 *  @param color 图片颜色
 *  @param size  图片大小（width、heigh）
 *
 *  @return 返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  十六进制的颜色转换为UIColor
 *
 *  @param color 16进制颜色字符串
 *
 *  @return 返回iOS颜色
 */
+ (UIColor *) colorWithStringRGB:(NSString *)color;

/**
 *  实现数字格式，每隔3位添加一个逗号的
 *
 *  如：123456789
 *  变为：123,456,789
 */
+(NSString *)countNumAndChangeformat:(NSString *)num;

/**
 *  判断手机号格式是否正确
 */
+ (BOOL)isRealMobileNumber:(NSString *)mobileNum;

/**
 *  把格式化的JSON格式的字符串转换成字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  把字典转化成json串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 cache clean
 **/
+ (void)cacheClean;

/**
 分割html文字
 **/
+ (NSString *)filterHTML:(NSString *)html;

/**
 * float类型转化成字符串 只舍不入
 *
 *  @param price    需要处理的数字，
 *  @param position 保留小数点第几位
 */
+ (NSString *)notRounding:(CGFloat)price afterPoint:(int)position;
@end
