//
//  TimeHandler.m
//  DDTG
//
//  Created by 季勤强 on 16/5/16.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "TimeHandler.h"

@implementation TimeHandler

+ (NSString*)handleHm:(NSString *)time{
    if (time.length != 4) {
        return @"";
    }
    NSMutableString* mutableString = [NSMutableString stringWithString:time];
    [mutableString insertString:@":" atIndex:2];
    if ([[time substringToIndex:0] isEqualToString:@"0"]) {
        [mutableString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return [mutableString copy];
}

+ (NSString *)handleYm:(NSString *)date{
    if (date.length != 8) {
        return @"";
    }
    NSMutableString* mutableString = [NSMutableString stringWithString:date];
    [mutableString deleteCharactersInRange:NSMakeRange(6, 2)];
    [mutableString insertString:@"-" atIndex:4];
    return [mutableString copy];
}

@end
