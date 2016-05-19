//
//  HandleString.h
//  LeYou
//
//  Created by 翟玉磊 on 14-9-12.
//  Copyright (c) 2014年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>
// 对字符串的一些操作
@interface HandleString : NSObject

/**
 *  计算字符串长度
 *
 *  @param text 文本
 *
 *  @return 字符串长度
 */
+ (int)textLength:(NSString *)text;

/**
 *  处理JSONValue failed
 *
 *  @param inputStr 传入的字符串
 *
 *  @return 正常的JSON string
 */
+ (NSString *)removeUnescapedCharacter:(NSString *)inputStr;//

/**
 *  去除字符串末尾的空格
 *
 *  @param string 待处理的字符串
 *
 *  @return 处理后的字符串
 */
+ (NSString *)getSubString:(NSString *)string;

/**
 *  获取一定宽度下的文本高度
 *
 *  @param lableString 文本内容
 *  @param startSize   文本存放的size
 *  @param font        文本字体
 *
 *  @return 文本高度
 */
+ (float)lableHeight:(NSString *)lableString withSize:(CGSize )startSize withFont:(UIFont *)font;

/**
 *  获取一定高度下的文本宽度
 *
 *  @param lableString 文本内容
 *  @param startSize   文本存放的size
 *  @param font        文本字体
 *
 *  @return 文本宽度
 */
+ (float)lableWidth:(NSString *)lableString withSize:(CGSize )startSize withFont:(UIFont *)font;
/**
 *  判断字符串是否包含某一字符串
 *
 *  @param content   原字符串
 *  @param subString  匹配的字符串
 *
 *  @return YES 包含subString  NO 不包含
 */
+ (BOOL)contentHaveSubString:(NSString *)content withSubString:(NSString *)subString;

/**
 *  判断字符串是否包含某一字符串
 *
 *  @param str  长字符串参数
 *  @param str1 短字符串参数
 *
 *  @return 返回短字符串在长字符串的位置
 */
+ (NSRange)judgeWithContainsString:(NSString *)str short:(NSString *)str1;

/**
 *  修改label中指定字符串的颜色
 *
 *  @param label 要修改的label
 *  @param str   要改变颜色的字符串
 *  @param is    label的最后一个字是否要改变颜色
 */
+ (void)changeLabelColor:(UILabel *)label string:(NSString *)str end:(BOOL)is;

/**
 *  将url 的& 和 ＝ 对应的数据存入字典
 *
 *  @param query   原字符串
 *  @param encoding  字符串编码 defalut NSUTF8StringEncoding
 *
 *  @return 字典
 */
+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding;


/**
 *  加法
 */
+ (NSString *)decimalNumberAddtionWithBefore:(NSString *)bNum after:(NSString *)aNum;

/**
 *  减法
 */
+ (NSString *)decimalNumberSubtractionWithBefore:(NSString *)bNum after:(NSString *)aNum;

/**
 *  乘法
 */
+ (NSString *)decimalNumberMultiplicationWithBefore:(NSString *)bNum after:(NSString *)aNum;
@end
