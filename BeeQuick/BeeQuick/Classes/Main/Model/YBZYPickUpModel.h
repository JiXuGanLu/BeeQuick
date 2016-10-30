//
//  YBZYPickUpModel.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBZYPickUpModel : NSObject

@property (nonatomic, copy) NSString *id;
//名称
@property (nonatomic, copy) NSString *dealer_alias;
//地址
@property (nonatomic, copy) NSString *address;
//起
@property (nonatomic, copy) NSString *WorkBegin;
//末
@property (nonatomic, copy) NSString *WorkEnd;
//距离
@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, copy) NSString *workingTimeString;

@end
