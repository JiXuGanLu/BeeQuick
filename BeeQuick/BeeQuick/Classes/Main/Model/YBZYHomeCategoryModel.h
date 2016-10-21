//
//  YBZYHomeCategoryModel.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBZYHomeCategoryActivityModel.h"
#import "YBZYHomeCategoryDetailModel.h"

@interface YBZYHomeCategoryModel : NSObject

@property (nonatomic,strong) YBZYHomeCategoryActivityModel *activity;

@property (nonatomic,strong) YBZYHomeCategoryDetailModel *category_detail;

@end
