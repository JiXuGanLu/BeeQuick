//
//  YBZYGoodModel.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBZYGoodModel : NSObject

//商品ID
@property (nonatomic, assign) NSInteger id;
//商品名
@property (nonatomic, copy) NSString * name;
//规格
@property (nonatomic, copy) NSString * specifics;
//市场价
@property (nonatomic, assign) CGFloat market_price;
//商品类型
@property (nonatomic, assign) NSInteger goods_type;
//精选
@property (nonatomic, copy) NSString * tag_ids;
//搜索关键字
@property (nonatomic, copy) NSString * keywords;
//价格
@property (nonatomic, assign) CGFloat price;
//商家
@property (nonatomic, assign) NSInteger dealer_id;
//折扣信息
@property (nonatomic, copy) NSString * pm_desc;
//图片地址
@property (nonatomic, copy) NSString * img;
// 跳转URL
@property (nonatomic, copy) NSString *urlString;
// 订购数量
@property (nonatomic, assign) NSInteger orderCount;

//经过处理的价格字符串
@property (nonatomic, copy) NSString *priceString;

@property (nonatomic, copy) NSString *market_priceString;

@property (nonatomic, copy) NSAttributedString *market_priceAttr;

@end
