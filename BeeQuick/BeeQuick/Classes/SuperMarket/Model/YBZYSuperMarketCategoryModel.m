//
//  YBZYSuperMarketCategoryModel.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/23.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSuperMarketCategoryModel.h"

@implementation YBZYSuperMarketCategoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cids" : NSClassFromString(@"YBZYSuperMarketCidModel")};
}

@end
