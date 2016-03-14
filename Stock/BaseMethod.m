//
//  BaseMethod.m
//  BaseMethodDemo
//
//  Created by 翟玉磊 on 15/11/5.
//  Copyright © 2015年 翟玉磊. All rights reserved.
//

#import "BaseMethod.h"
#import <CommonCrypto/CommonDigest.h>   //md5

@implementation BaseMethod

+(BOOL)isNOTNull:(id)object {
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object==nil){
        return NO;
    }
    else if ([[NSString stringWithFormat:@"%@", object] isEqualToString:@""] ||[[NSString stringWithFormat:@"%@", object] isEqualToString:@" "]){
        return NO;
    }
    else if ([[[NSString stringWithFormat:@"%@", object] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0){
        return NO;
    }
    
    return YES;
}

+ (NSString *)toString :(id)id {
    
    if([id isKindOfClass:[NSString class]]){
        return id;
    }else if ([id isKindOfClass:[NSNumber class]]){
        return [id stringValue];
    }
    else {
        return @"";
    }
}

+ (NSString *)getMd5WithString:(NSString *)string {
    
    const char * original_str = [string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [outPutStr appendFormat:@"%02x",digist[i]];
        
    }

    return [outPutStr lowercaseString];
}

#define UpYunImageURLPrefix @"http://shike-image.b0.upaiyun.com"
+ (NSURL *)getImageURLWith:(NSString *)string need:(NSString *)need {
    NSURL *url;
    //防止字符串有中文字符
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (string.length > 1) {
        NSRange range = [string rangeOfString:@"http://"];
        if (range.location == NSNotFound) {
            if ([BaseMethod isNOTNull:need]) {
                //有要求
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@!%@",UpYunImageURLPrefix,string,need]];
            }else {
                //没要求
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UpYunImageURLPrefix,string]];
            }
        }else {
            if ([BaseMethod isNOTNull:need]) {
                //有要求
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!%@",string,need]];
            }else {
                //没要求
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",string]];
            }
        }
    }else {
        url = [NSURL URLWithString:@""];
    }
    return url;
}

+ (NSURL *)getImageURLWith:(NSString *)string {

    NSURL *url;
    if (string.length > 1) {
        NSRange range = [string rangeOfString:@"http://"];
        if (range.location == NSNotFound) {
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UpYunImageURLPrefix,string]];
        }else {
           
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",string]];
        }
    }else {
        url = [NSURL URLWithString:@""];
    }
    return url;
}

+ (NSURL *)getVoiceURLWith:(NSString *)string {
    NSURL *url;
    if (string.length > 1) {
        NSRange range = [string rangeOfString:@"http://"];
        if (range.location == NSNotFound) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UpYunImageURLPrefix,string]];
            
        }else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",string]];
        }
    }else {
        url = [NSURL URLWithString:@""];
    }
    return url;
}

+ (void)saveDataPath:(NSString *)path withData:(NSData *)data {
    //data保存的路径
    //这里将data放到沙盒的documents文件夹中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",path]];
        [data writeToFile:filePath atomically:YES]; //写入文件夹
    });
}


+ (void)removeFile:(NSString *)path {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:path];  //文件的完整地址
        
        NSFileManager *fileManager = [NSFileManager defaultManager];//文件管理器
        BOOL bRet = [fileManager fileExistsAtPath:filePath];
        if (bRet) {
            NSError *err;
            [fileManager removeItemAtPath:filePath error:&err];
        }
    });
}

+ (UIImage *)getImageWithFilePath:(NSString *)path {
    //确保这个地址是后缀
    NSArray *array = [path componentsSeparatedByString:@"/"];
    NSString *string = [array lastObject];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",string]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

+ (NSData *)getDataWithFilePath:(NSString *)path {
    NSArray *array = [path componentsSeparatedByString:@"/"];
    NSString *string = [array lastObject];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",string]];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

//图片由颜色值生成
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithStringRGB:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//实现数字格式，每隔3位添加一个逗号的
+(NSString *)countNumAndChangeformat:(NSString *)num {
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)    {
        count++;        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

/**
 *  判断手机号格式是否正确
 */
+ (BOOL)isRealMobileNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1[3|4|5|8][0-9]\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    
    return dic;
}
    
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {

    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}

+ (void)cacheClean{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //要清除的文件
        NSArray* files = [[NSFileManager defaultManager] subpathsAtPath:path];
        for (NSString* file in files) {
            NSError* error = nil;
            NSString* cachePath = [path stringByAppendingPathComponent:file];
            if([[NSFileManager defaultManager] fileExistsAtPath:cachePath]){
                [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error];
            }
        }
    });
}

+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

+ (NSString *)notRounding:(CGFloat)price afterPoint:(int)position {
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
    
}

@end
