//
//  YBZYHomeCategoryDetailModel.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeCategoryDetailModel.h"

@implementation YBZYHomeCategoryDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods" : NSClassFromString(@"YBZYGoodModel")};
}

@end
