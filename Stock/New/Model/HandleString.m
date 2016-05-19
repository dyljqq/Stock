//
//  HandleString.m
//  LeYou
//
//  Created by 翟玉磊 on 14-9-12.
//  Copyright (c) 2014年 翟玉磊. All rights reserved.
//

#import "HandleString.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation HandleString
+ (int)textLength:(NSString *)text//计算字符串长度
{
    if (text == nil) {
        return 0;
    }
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    
    //英文字條件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合英文字條件的有幾個字元
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    number = number + tLetterMatchCount * 0.5;
    return ceil(number);
}
+  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}

//处理JSONValue failed. Error trace is: Unescaped control character
+ (NSString *)removeUnescapedCharacter:(NSString *)inputStr
{
    
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    
    NSRange range = [inputStr rangeOfCharacterFromSet:controlChars];
    
    if (range.location != NSNotFound)
    {
        
        NSMutableString *mutable = [NSMutableString stringWithString:inputStr];
        
        while (range.location != NSNotFound)
        {
            
            [mutable deleteCharactersInRange:range];
            
            range = [mutable rangeOfCharacterFromSet:controlChars];
            
        }
        
        return mutable;
        
    }
    
    return inputStr;
}

//去除字符串末尾的空格
+ (NSString *)getSubString:(NSString *)string{
    if ([string hasSuffix:@" "]) {
        string = [string substringWithRange:NSMakeRange(0, string.length - 1)];
        return [self getSubString:string];
    }else{
        return string;
    }
}

+ (float)lableHeight:(NSString *)lableString withSize:(CGSize )startSize withFont:(UIFont *)font{
    @autoreleasepool {
        if (lableString.length < 1) {
            return 0;
        }
        NSDictionary *attribute = @{NSFontAttributeName: font};
        startSize = CGSizeMake(startSize.width, MAXFLOAT);
        CGFloat retHeight = [lableString boundingRectWithSize:startSize
                                                      options:
                             NSStringDrawingTruncatesLastVisibleLine |
                             NSStringDrawingUsesLineFragmentOrigin |
                             NSStringDrawingUsesFontLeading
                                                   attributes:attribute
                                                      context:nil].size.height;
        return retHeight + 1;
    }
}

+ (float)lableWidth:(NSString *)lableString withSize:(CGSize )startSize withFont:(UIFont *)font{
    @autoreleasepool {
        if (lableString.length < 1) {
            return 0;
        }
        NSDictionary *attribute = @{NSFontAttributeName: font};
        startSize = CGSizeMake(MAXFLOAT, startSize.height);
        CGFloat retWidth = [lableString boundingRectWithSize:startSize
                                                     options:
                            NSStringDrawingTruncatesLastVisibleLine |
                            NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading
                                                  attributes:attribute
                                                     context:nil].size.width;
        
        return retWidth + 1;
    }
}

+ (BOOL)contentHaveSubString:(NSString *)content withSubString:(NSString *)subString {
    NSRange range = [content rangeOfString:subString];
    if (range.location != NSNotFound)
        return YES;
    return NO;
}

+ (NSRange)judgeWithContainsString:(NSString *)str short:(NSString *)str1 {
    
    NSRange r = [str rangeOfString:str1];
    if (r.location != NSNotFound) {
        return r;
    }else {
        return NSMakeRange(0, 0);
    }
}

+ (void)changeLabelColor:(UILabel *)label string:(NSString *)str end:(BOOL)is {
    
    NSRange r = [HandleString judgeWithContainsString:label.text short:str];
    if (r.location == 0) {
        //不包含
        return;
    }
    r = NSMakeRange(r.location, str.length);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
    
    [string addAttribute:NSForegroundColorAttributeName value:NavColor range:r];
    
    if (is) {//最后一个字符是否要改变颜色
        
        [string addAttribute:NSForegroundColorAttributeName value:TextGrayColor range:NSMakeRange(label.text.length - 1, 1)];
        
    }
    label.attributedText = string;
}

+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    if (!encoding) {
        encoding = NSUTF8StringEncoding;
    }
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query] ;
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

//加法
+ (NSString *)decimalNumberAddtionWithBefore:(NSString *)bNum after:(NSString *)aNum {
    
    NSDecimalNumber *price1 = [NSDecimalNumber decimalNumberWithString:bNum];
    NSDecimalNumber *price2 = [NSDecimalNumber decimalNumberWithString:aNum];
    
    NSDecimalNumber *addDecimalNumer = [price1 decimalNumberByAdding:price2];
    return [NSString stringWithFormat:@"%@",addDecimalNumer];
}

//减法
+ (NSString *)decimalNumberSubtractionWithBefore:(NSString *)bNum after:(NSString *)aNum {
    
    NSDecimalNumber *price1 = [NSDecimalNumber decimalNumberWithString:bNum];
    NSDecimalNumber *price2 = [NSDecimalNumber decimalNumberWithString:aNum];
    
    NSDecimalNumber *addDecimalNumer = [price1 decimalNumberBySubtracting:price2];
    return [NSString stringWithFormat:@"%@",addDecimalNumer];
}

//乘法
+ (NSString *)decimalNumberMultiplicationWithBefore:(NSString *)bNum after:(NSString *)aNum {
    
    NSDecimalNumber *price1 = [NSDecimalNumber decimalNumberWithString:bNum];
    NSDecimalNumber *price2 = [NSDecimalNumber decimalNumberWithString:aNum];
    
    NSDecimalNumber *addDecimalNumer = [price1 decimalNumberByMultiplyingBy:price2];
    return [NSString stringWithFormat:@"%@",addDecimalNumer];
}
@end
