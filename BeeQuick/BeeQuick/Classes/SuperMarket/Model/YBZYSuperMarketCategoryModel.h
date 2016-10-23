//
//  YBZYSuperMarketCategoryModel.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/23.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBZYSuperMarketCidModel.h"

@interface YBZYSuperMarketCategoryModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *nameKey;

@property (nonatomic, strong) NSArray<YBZYSuperMarketCidModel *> *cids;

@property (nonatomic, copy) NSString *icon;

@end
