//
//  YBZYHomeCategoryDetailModel.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBZYHomeCategoryDetailModel : NSObject
// 标题
@property (nonatomic, copy) NSString *name;
// 标题颜色
@property (nonatomic, copy) NSString *category_color;
// 商品详情模型数组
@property (nonatomic,strong) NSArray<YBZYGoodModel *> *goods;
// 分类id
@property (nonatomic, copy) NSString *category_id;

@end
