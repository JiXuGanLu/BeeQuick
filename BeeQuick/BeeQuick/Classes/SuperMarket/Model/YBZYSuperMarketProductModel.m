//
//  YBZYSuperMarketProductModel.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/23.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSuperMarketProductModel.h"

@implementation YBZYSuperMarketProductModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"hot" : NSClassFromString(@"YBZYGoodModel"),
       @"vagatable" : NSClassFromString(@"YBZYGoodModel"),
           @"daily" : NSClassFromString(@"YBZYGoodModel"),
           @"fruit" : NSClassFromString(@"YBZYGoodModel"),
       @"milkBread" : NSClassFromString(@"YBZYGoodModel"),
      @"cookedFood" : NSClassFromString(@"YBZYGoodModel"),
           @"drink" : NSClassFromString(@"YBZYGoodModel"),
            @"tips" : NSClassFromString(@"YBZYGoodModel"),
             @"ice" : NSClassFromString(@"YBZYGoodModel"),
       @"quickFood" : NSClassFromString(@"YBZYGoodModel"),
        @"dailyUse" : NSClassFromString(@"YBZYGoodModel"),
             @"oil" : NSClassFromString(@"YBZYGoodModel")};
}

@end
