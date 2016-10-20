//
//  YBZYHTTPSessionManager.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, YBZYHTTPMethod) {
    YBZYHTTPMethodGet = 0,
    YBZYHTTPMethodPost
};

@interface YBZYHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedSessionManager;

- (void)requestMethod:(YBZYHTTPMethod)method URLString:(NSString *)URLString parameters:(id)parameters completion:(void(^)(id response, NSError *error))completion;

@end
