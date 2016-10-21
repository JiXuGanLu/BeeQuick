//
//  YBZYGoodModel.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYGoodModel.h"

@implementation YBZYGoodModel

- (NSString *)urlString {
    return [NSString stringWithFormat:@"http://m.beequick.cn/show/productDetail?id=%zd&shopId=%ld", self.id, self.dealer_id];
}

@end
