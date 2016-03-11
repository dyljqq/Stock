//
//  JQQRequest.m
//  AFNetworkingDemo
//
//  Created by 季勤强 on 16/3/11.
//  Copyright © 2016年 季勤强. All rights reserved.
//

#import "JQQRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation JQQRequest{
    NSMutableDictionary* params;
    NSURL* requestUrl;
    AFURLSessionManager* manager;
}

- (instancetype)initWithUrlString:(NSString *)urlString{
    self =[super init];
    if(self){
        [self initParam:urlString];
    }
    return self;
}

- (void)initParam:(NSString*)urlString{
    requestUrl = [NSURL URLWithString:urlString];
    _requestType = REQUEST_TYPE_GET;
    _transmissionFormat = TRANSMISSION_FORMAT_HTTP;
    params = [NSMutableDictionary dictionary];
    manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (void)setParam:(id)param key:(NSString *)key{
    if (param) {
        [params setValue:param forKey:key];
    }else{
        NSLog(@"param cannot be nil");
    }
}

- (void)callback:(void (^)(JQQResponse *))callback{
    NSMutableURLRequest* request = nil;
    NSString* type = @"";
    switch (_requestType) {
        case REQUEST_TYPE_GET:
            type = @"GET";
            break;
            
        case REQUEST_TYPE_POST:
            type = @"POST";
            break;
            
        default:
            break;
    }
    switch (_transmissionFormat) {
        case TRANSMISSION_FORMAT_HTTP:
            request = [[AFHTTPRequestSerializer serializer] requestWithMethod:type URLString:[requestUrl absoluteString] parameters:params error:nil];
            break;
            
        case TRANSMISSION_FORMAT_JSON:
            request = [[AFJSONRequestSerializer serializer] requestWithMethod:type URLString:[requestUrl absoluteString] parameters:params error:nil];
            break;
            
        default:
            break;
    }
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
        JQQResponse* res = [JQQResponse new];
        res.data = responseObject;
        res.code = [[responseObject valueForKey:@"code"] integerValue];
        res.message = [responseObject valueForKey:@"message"];
        if(callback){
            callback(res);
        }
    }];
    [dataTask resume];
}

+ (void)downloadTask:(NSString*)urlString callback:(JQQRequestCallbackBlock)callback{
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

+ (void)uploadTask:(NSString*)urlString filePath:(NSString*)filePathString callback:(JQQRequestCallbackBlock)callback{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:filePathString] progress:nil completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
        NSLog(@"File downloaded to: %@", filePath);
    }];
}

+ (void)uploadFormTask:(NSString*)urlString filePath:(NSString*)filePathString callback:(JQQRequestCallbackBlock)callback{
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
        //filename:the download file's name
        [formData appendPartWithFileURL:[NSURL URLWithString:filePathString] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    }error:nil];
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask* uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}



@end
