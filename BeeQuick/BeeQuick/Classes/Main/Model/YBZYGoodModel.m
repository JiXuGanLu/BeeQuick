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
    return [NSString stringWithFormat:@"http://m.beequick.cn/show/productDetail?id=%zd&shopId=%zd", self.id, self.dealer_id];
}

- (NSString *)priceString {
    if (fmodf(self.price, 1) == 0) {
        return [NSString stringWithFormat:@"¥%.0lf", self.price];
    }
    else if (fmodf(self.price * 10, 1) == 0) {
        return [NSString stringWithFormat:@"¥%.1lf", self.price];
    }
    else {
        return [NSString stringWithFormat:@"¥%.2lf", self.price];
    }
}

- (NSString *)market_priceString {
    if (fmodf(self.market_price, 1) == 0) {
        return [NSString stringWithFormat:@"¥%.0lf", self.market_price];
    }
    else if (fmodf(self.market_price * 10, 1) == 0) {
        return [NSString stringWithFormat:@"¥%.1lf", self.market_price];
    }
    else {
        return [NSString stringWithFormat:@"¥%.2lf", self.market_price];
    }
}

- (NSAttributedString *)market_priceAttr {
    return [[NSAttributedString alloc]initWithString:self.market_priceString attributes:
            @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
              NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
              NSStrikethroughColorAttributeName:[UIColor lightGrayColor]}];
}

@end
