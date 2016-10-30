//
//  YBZYAddressModel.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressModel.h"

@implementation YBZYAddressModel

- (NSString *)receiverString {
    return [NSString stringWithFormat:@"%@  %@", self.name, self.telNumber];
}

- (NSString *)addressString {
    return [NSString stringWithFormat:@"%@  %@", self.district, self.detail];
}

@end
