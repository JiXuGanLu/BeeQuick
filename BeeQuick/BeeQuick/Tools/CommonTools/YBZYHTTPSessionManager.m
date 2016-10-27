//
//  YBZYHTTPSessionManager.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHTTPSessionManager.h"

@implementation YBZYHTTPSessionManager

+ (instancetype)sharedSessionManager {
    static YBZYHTTPSessionManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [self manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSSet *set = [NSSet setWithObjects:@"text/plain", @"text/html", nil];
            manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:set];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        }
    });
    
    return manager;
}

- (void)requestMethod:(YBZYHTTPMethod)method URLString:(NSString *)URLString parameters:(id)parameters completion:(void (^)(id, NSError *))completion {
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    };
    void(^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    };
    
    if (method == YBZYHTTPMethodGet) {
        [self GET:URLString parameters:parameters progress:nil success:successBlock failure:failureBlock];
    } else {
        [self POST:URLString parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
}

@end
