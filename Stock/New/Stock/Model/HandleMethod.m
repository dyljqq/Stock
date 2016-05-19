//
//  HandleMethod.m
//  DDTG
//
//  Created by 季勤强 on 16/5/17.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "HandleMethod.h"

@implementation HandleMethod

+ (NSString*)handleTapeData:(CGFloat)data{
    if (data < pow(10, 4)) {
        return [NSString stringWithFormat:@"%.2f", data];
    }else if (data > 10000 && data < pow(10, 8)) {
        return [NSString stringWithFormat:@"%.2f万", data / pow(10, 4)];
    }
    return [NSString stringWithFormat:@"%.2f亿", data / pow(10, 8)];
}

@end
