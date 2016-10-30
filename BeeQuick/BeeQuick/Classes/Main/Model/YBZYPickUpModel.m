//
//  YBZYPickUpModel.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYPickUpModel.h"

@implementation YBZYPickUpModel

- (NSString *)workingTimeString {
    return [NSString stringWithFormat:@"%@--%@", self.WorkBegin, self.WorkEnd];
}

@end
