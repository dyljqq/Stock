//
//  SKService.m
//  BaseMethodDemo
//
//  Created by 翟玉磊 on 15/11/10.
//  Copyright © 2015年 翟玉磊. All rights reserved.
//

#import "SKService.h"

@implementation SKService

- (id)initWithUrl:(NSString *)url andMethod:(NSString *)method andExplain:(NSString *)explain andType:(NSString *)type {
    
    self = [super init];
    if (self) {
        self.method = method;
        self.url = url;
        self.explain = explain;
        self.type = type;
    }
    return self;
}
@end
