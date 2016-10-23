//
//  YBZYHomeCategoryModel.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeCategoryModel.h"

@implementation YBZYHomeCategoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"activity" : NSClassFromString(@"YBZYHomeCategoryActivityModel"),
      @"category_detail" : NSClassFromString(@"YBZYHomeCategoryDetailModel")};
}

@end
