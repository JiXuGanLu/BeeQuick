//
//  YBZYAddressModel.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBZYAddressModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *telNumber;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *district;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSString *receiverString;

@property (nonatomic, copy) NSString *addressString;

@property (nonatomic, assign) NSTimeInterval creatTime;

@end
