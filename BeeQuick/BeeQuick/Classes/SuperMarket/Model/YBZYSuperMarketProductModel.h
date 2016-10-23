//
//  YBZYSuperMarketProductModel.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/23.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBZYGoodModel.h"

@interface YBZYSuperMarketProductModel : NSObject

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *hot;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *daily;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *fruit;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *milkBread;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *cookedFood;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *drink;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *tips;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *ice;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *quickFood;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *dailyUse;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *oil;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *vagatable;

@end
