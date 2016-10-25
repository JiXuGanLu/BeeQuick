//
//  YBZYHomeCategoryActivityModel.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeCategoryActivityModel.h"

@implementation YBZYHomeCategoryActivityModel

- (NSString *)urlString {
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"http://m.beequick.cn/show/active?id=%@&locationHash=22b1d6HSvnApApLAM2a34IlDZHIjcriyWHEqY4G+K8p0MnFn39NEdxbnto&zchtid=12064&location_time=%f&cityid=2", self.id, time];
}

@end
