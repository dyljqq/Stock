//
//  HandicapModel.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "HandicapModel.h"

@implementation HandicapModel

+ (void)getHandicapRequest:(NSString *)urlString callback:(void (^)(NSArray *))callback{    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSSet *set = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", @"application/x-javascript", nil];
    manager.responseSerializer.acceptableContentTypes = set;
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString* str = operation.responseString;
        NSArray* array = [str componentsSeparatedByString:@"\""];
        NSArray* data = [array count] > 0 ? [array[1] componentsSeparatedByString:@","] : [NSArray array];
        if(callback)
            callback(data);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error:%@", error);
    }];
}

@end
