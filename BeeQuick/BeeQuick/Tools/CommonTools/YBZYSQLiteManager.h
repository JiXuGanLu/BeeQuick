//
//  YBZYSQLiteManager.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YBZYSQLOrderType) {
    YBZYSQLOrderTypeNormal = 0,
    YBZYSQLOrderTypePriceAscending,
    YBZYSQLOrderTypePriceDescending
};

@interface YBZYSQLiteManager : NSObject

#pragma mark - 单例方法

+ (instancetype)sharedManager;

#pragma mark - 超市商品数据库接口

/**
 缓存超市商品数据

 @param goodModel 传入要缓存的商品模型
 */
- (void)cacheSuperMarketGood:(YBZYGoodModel *)goodModel;

/**
 加载超市商品数据

 @param categoryId 分类id
 @param childCid    子分类id
 @param orderType  排序规则

 @return 数据库查询结果, 结果为包含字典的数组, 数组里的每一个字典对应一种商品的相关信息字典(包含模型/id/categoryId/childId/价格)
 */
- (NSArray<NSDictionary *> *)loadSuperMarketGoodWithCategoryId:(NSInteger)categoryId childCid:(NSInteger)childCid orderBy:(YBZYSQLOrderType)orderType;

/**
 清除超市商品数据
 */
- (void)clearCachedSuperMarketGood;

#pragma mark - 购物车数据库接口

/**
 商品添加购物车的方法
 
 @param goodModel 传入商品对应的模型
 @param goodId    传入商品id
 @param userId    userId，PCH定义了YBZYUserId，直接写YBZYUserId
 @param type      传入商品模型的goods_type属性
 */
- (void)addGood:(YBZYGoodModel *)goodModel withId:(NSInteger)goodId userId:(NSInteger)userId goodsType:(NSInteger)type;

/**
 减少商品数量的方法, 调用此方法购物车该商品的数量-1
 
 @param goodId    传入商品id
 @param userId    userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)reduceGoodWithId:(NSInteger)goodId userId:(NSInteger)userId;

/**
 修改某个商品在购物车中的选中状态
 
 @param isSelected 要修改到的状态
 @param goodId     商品id
 @param userId     userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)changeGoodCondition:(NSInteger)isSelected inShopCartWithId:(NSInteger)goodId userId:(NSInteger)userId;

/**
 修改某个类型商品在购物车中的选中状态
 
 @param isSelected 要修改到的状态
 @param type       传入商品模型的goods_type属性
 @param userId     userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)changeGoodCondition:(NSInteger)isSelected inShopCartWithGoodsType:(NSInteger)type userId:(NSInteger)userId;

/**
 修改所有商品在购物车中的选中状态
 
 @param isSelected 要修改到的状态
 @param userId     userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)changeAllGoodCondition:(NSInteger)isSelected inShopCartWithUserId:(NSInteger)userId;

/**
 删除商品的方法, 调用此方法删除购物车中所有该商品
 
 @param goodId 传入商品id
 @param userId userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)deleteGoodWithId:(NSInteger)goodId userId:(NSInteger)userId;

/**
 实时查询某用户购物车中所有商品的信息
 
 @param userId userId，PCH定义了YBZYUserId，直接写YBZYUserId
 
 @return 购物车数据库查询结果, 结果为包含字典的数组, 数组里的每一个字典对应一种商品的相关信息字典(包含模型/id/数量/userId/超市或者预购类型)
 */
- (NSArray<NSDictionary *> *)getAllGoodsInShopCartWithUserId:(NSInteger)userId;

/**
 实时查询某用户购物车中某一个商品的信息
 
 @param goodId 商品Id
 @param userId userId，PCH定义了YBZYUserId，直接写YBZYUserId
 
 @return 购物车数据库查询结果, 结果为包含该商品信息字典的数组, 也就是如果数组里有一个字典说明购物车中有此商品
 */
- (NSArray<NSDictionary *> *)getGoodInShopCartWithGoodId:(NSInteger)goodId userId:(NSInteger)userId;

#pragma mark - 用户地址数据库接口

/**
 添加用户地址
 
 @param addressModel 要存储的地址模型
 @param userId       userId，PCH定义了YBZYUserId，直接写YBZYUserId
 @param creatTime    地址模型的creatTime属性
 */
- (void)addUserAddress:(YBZYAddressModel *)addressModel withUserId:(NSInteger)userId creatTime:(NSInteger)creatTime;

/**
 删除用户地址
 
 @param creatTime 地址模型的creatTime属性
 @param userId    userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)deleteUserAddressWithAddressCreatTime:(NSInteger)creatTime userId:(NSInteger)userId;

/**
 设定选中的送货地址
 
 @param creatTime 地址模型的creatTime属性
 @param userId    userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)setCurrentUserAddressWithAddressCreatTime:(NSInteger)creatTime userId:(NSInteger)userId;

/**
 获取用户当前选择的送货地址
 
 @param userId userId，PCH定义了YBZYUserId，直接写YBZYUserId
 
 @return 结果为包含一个字典的数组, 这个字典对应地址的相关信息(包含地址模型/序号/userId)
 */
- (NSArray<NSDictionary *> *)getCurrentUserAddressWithUserId:(NSInteger)userId;

/**
 查询用户添加的所有地址
 
 @param userId userId，PCH定义了YBZYUserId，直接写YBZYUserId
 
 @return 用户地址数据库查询结果, 结果为包含字典的数组, 数组里的每一个字典对应一个地址的相关信息字典(包含地址模型/序号/userId/是否选择为当前地址)
 */
- (NSArray<NSDictionary *> *)getAllUserAddressWithUserId:(NSInteger)userId;

/**
 更新用户已有地址

 @param creatTime 地址模型的creatTime属性
 @param userId    用户ID，直接写YBZYUserId
 */
- (void)updateUserAddress:(YBZYAddressModel *)addressModel withAddressCreatTime:(NSInteger)creatTime userId:(NSInteger)userId;

/**
 取消用户设定的当前地址

 @param userId 用户ID，直接写YBZYUserId
 */
- (void)cancelCurrentSelectedUserAddressWithUserId:(NSInteger)userId;

#pragma mark - 自提点数据库接口

/**
 用户设置自提点的接口
 
 @param pickUpModel 选中的自提点模型
 @param userId      userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)setPickUp:(YBZYPickUpModel *)pickUpModel withUserId:(NSInteger)userId;

/**
 取到用户设置的自提点
 
 @param userId userId，PCH定义了YBZYUserId，直接写YBZYUserId
 
 @return 用户自提点数据库查询结果, 结果为包含一个字典的数组, 字典信息(包含地址模型/序号/userId/是否选择为当前地址)
 */
- (NSArray<NSDictionary *> *)getPickUpWithUserId:(NSInteger)userId;

/**
 删除用户选择的自提点

 @param userId 直接写YBZYUserId
 */
- (void)deletePickUpWithUserId:(NSInteger)userId;

#pragma mark - 商品收藏数据库接口

/**
 添加商品收藏
 
 @param goodModel 添加的商品模型
 @param goodId    商品id
 @param userId    userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)addCollectionGood:(YBZYGoodModel *)goodModel withId:(NSInteger)goodId userId:(NSInteger)userId;

/**
 删除商品收藏
 
 @param goodId    商品id
 @param userId    userId，PCH定义了YBZYUserId，直接写YBZYUserId
 */
- (void)deleteCollectionGoodWithId:(NSInteger)goodId userId:(NSInteger)userId;

/**
 获取用户的商品收藏
 
 @param userId userId，PCH定义了YBZYUserId，直接写YBZYUserId
 
 @return 用户商品收藏结果数组, 数组中的元素都是字典, 每一个字典包含商品模型/商品id和用户id
 */
- (NSArray<NSDictionary *> *)getCollectionGoodsWithUserId:(NSInteger)userId;

@end
