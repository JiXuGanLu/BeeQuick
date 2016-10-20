//
//  YBZYSQLiteManager.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSQLiteManager.h"
#import "FMDB.h"

static NSString *dbFileName = @"ybzyBeeQuickDatabase.db";

@interface YBZYSQLiteManager ()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation YBZYSQLiteManager

#pragma mark - 全局单例

+ (instancetype)sharedManager {
    static YBZYSQLiteManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject stringByAppendingPathComponent:dbFileName];
        instance.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        [instance creatTables];
    });
    
    return instance;
}

#pragma mark - 创表

-  (void)creatTables {
    NSString *shopCartPath = [[NSBundle mainBundle] pathForResource:@"shopCart.sql" ofType:nil];
    NSString *pickUpPath = [[NSBundle mainBundle] pathForResource:@"pickUp.sql" ofType:nil];
    NSString *userAddressPath = [[NSBundle mainBundle] pathForResource:@"userAddress.sql" ofType:nil];
    NSString *collectionGoodsPath = [[NSBundle mainBundle] pathForResource:@"collectionGoods.sql" ofType:nil];
    
    NSString *shopCartsql = [NSString stringWithContentsOfFile:shopCartPath encoding:NSUTF8StringEncoding error:nil];
    NSString *pickUpSql = [NSString stringWithContentsOfFile:pickUpPath encoding:NSUTF8StringEncoding error:nil];
    NSString *userAddressSql = [NSString stringWithContentsOfFile:userAddressPath encoding:NSUTF8StringEncoding error:nil];
    NSString *collectionGoodsSql = [NSString stringWithContentsOfFile:collectionGoodsPath encoding:NSUTF8StringEncoding error:nil];
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeStatements:shopCartsql];
        [db executeStatements:pickUpSql];
        [db executeStatements:userAddressSql];
        [db executeStatements:collectionGoodsSql];
    }];
}

#pragma mark - 封装高频使用的基本操作

- (NSArray<NSDictionary *> *)executeQueryResult:(NSString *)sqlString {
    NSMutableArray *result = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:sqlString];
        while (resultSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSUInteger colCount = resultSet.columnCount;
            for ( int i = 0; i < colCount; i++) {
                NSString *colName = [resultSet columnNameForIndex:i];
                id colValue = [resultSet objectForColumnIndex:i];
                dict[colName] = colValue;
            }
            [result addObject:dict.copy];
        }
    }];
    return result.copy;
}

- (void)executeUpdate:(NSString *)sql withArgumentArray:(NSArray *)array {
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result;
        
        if (array) {
            result = [db executeUpdate:sql withArgumentsInArray:array];
        } else {
            result = [db executeUpdate:sql];
        }
        
        if (!result) {
            *rollback = true;
            [SVProgressHUD showErrorWithStatus:@"出错了,请重新操作"];
        }
    }];
}

#pragma mark - 购物车商品增删改查

- (void)addGood:(YBZYGoodModel *)goodModel withId:(NSInteger)goodId userId:(NSInteger)userId goodsType:(NSInteger)type {
    NSString *searchSql = [NSString stringWithFormat:@"SELECT * FROM T_ShopCart WHERE id = %zd and userId = %zd;", goodId, userId];
    NSArray *searchResult = [self executeQueryResult:searchSql];
    //    NSLog(@"^%@",searchResult);
    
    if (searchResult.count) {
        //        NSData *data = searchResult.firstObject[@"goodModel"];
        //        YBZYGoodModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //        NSLog(@"%@",model);
        NSInteger count = [searchResult.firstObject[@"count"] integerValue];
        NSString *addSql = [NSString stringWithFormat:@"UPDATE T_ShopCart SET count = %zd WHERE id = %zd and userId = %zd;", (count + 1), goodId, userId];
        [self executeUpdate:addSql withArgumentArray:nil];
        [self changeGoodCondition:1 inShopCartWithId:goodId userId:userId];
        return;
    }
    
    NSData *goodData = [NSKeyedArchiver archivedDataWithRootObject:goodModel];
    NSString *insertSql = @"INSERT INTO T_ShopCart (id, userId, goodModel, type, count, selected) VALUES (?, ?, ?, ?, ?, ?);";
    [self executeUpdate:insertSql withArgumentArray:@[@(goodId), @(userId), goodData, @(type), @1, @1]];
}

- (void)reduceGoodWithId:(NSInteger)goodId userId:(NSInteger)userId {
    NSString *searchSql = [NSString stringWithFormat:@"SELECT * FROM T_ShopCart WHERE id = %zd and userId = %zd;", goodId, userId];
    NSArray *searchResult = [self executeQueryResult:searchSql];
    
    if (searchResult.count) {
        //        NSData *data = searchResult.firstObject[@"goodModel"];
        //        YBZYGoodModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //        NSLog(@"%@",model);
        NSInteger count = [searchResult.firstObject[@"count"] integerValue];
        
        NSString *reduceSql = [NSString stringWithFormat:@"UPDATE T_ShopCart SET count = %zd WHERE id = %zd and userId = %zd;", (count - 1), goodId, userId];
        if (count == 1) {
            reduceSql = [NSString stringWithFormat:@"DELETE FROM T_ShopCart WHERE id = %zd and userId = %zd;", goodId, userId];
        }
        
        [self executeUpdate:reduceSql withArgumentArray:nil];
    }
}

- (void)changeGoodCondition:(NSInteger)isSelected inShopCartWithId:(NSInteger)goodId userId:(NSInteger)userId {
    NSString *changeSql = [NSString stringWithFormat:@"UPDATE T_ShopCart SET selected = %zd WHERE id = %zd and userId = %zd;", isSelected, goodId, userId];
    [self executeUpdate:changeSql withArgumentArray:nil];
}

- (void)changeGoodCondition:(NSInteger)isSelected inShopCartWithGoodsType:(NSInteger)type userId:(NSInteger)userId {
    NSString *changeSql = [NSString stringWithFormat:@"UPDATE T_ShopCart SET selected = %zd WHERE type = %zd and userId = %zd;", isSelected, type, userId];
    [self executeUpdate:changeSql withArgumentArray:nil];
}

- (void)changeAllGoodCondition:(NSInteger)isSelected inShopCartWithUserId:(NSInteger)userId {
    NSString *changeSql = [NSString stringWithFormat:@"UPDATE T_ShopCart SET selected = %zd WHERE userId = %zd;", isSelected, userId];
    [self executeUpdate:changeSql withArgumentArray:nil];
}

- (void)deleteGoodWithId:(NSInteger)goodId userId:(NSInteger)userId {
    NSString *deleteSql = @"DELETE FROM T_ShopCart WHERE id = ? and userId = ?;";
    [self executeUpdate:deleteSql withArgumentArray:@[@(goodId), @(userId)]];
}

- (NSArray<NSDictionary *> *)getAllGoodsInShopCartWithUserId:(NSInteger)userId {
    NSString *getSql = [NSString stringWithFormat:@"SELECT * FROM T_ShopCart WHERE userId = %zd;", userId];
    return [self getGoodsWithSQL:getSql];
}

- (NSArray<NSDictionary *> *)getGoodInShopCartWithGoodId:(NSInteger)goodId userId:(NSInteger)userId {
    NSString *getSql = [NSString stringWithFormat:@"SELECT * FROM T_ShopCart WHERE id = %zd and userId = %zd;", goodId, userId];
    return [self getGoodsWithSQL:getSql];
}

- (NSArray<NSDictionary *> *)getGoodsWithSQL:(NSString *)sql {
    NSMutableArray *goods = [NSMutableArray array];
    
    NSArray *getResult = [self executeQueryResult:sql];
    for (NSDictionary *value in getResult) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:value];
        NSData *goodModelData = dict[@"goodModel"];
        YBZYGoodModel *goodModel = [NSKeyedUnarchiver unarchiveObjectWithData:goodModelData];
        dict[@"goodModel"] = goodModel;
        
        [goods addObject:dict.copy];
        NSLog(@"^--^%@",dict);
    }
    return goods.copy;
}

#pragma mark - 地址增删改查

- (void)addUserAddress:(YBZYAddressModel *)addressModel withUserId:(NSInteger)userId creatTime:(NSInteger)creatTime {
    [self deletePickUpWithUserId:userId];
    [self cancelCurrentSelectedUserAddressWithUserId:userId];
    
    NSData *addressData = [NSKeyedArchiver archivedDataWithRootObject:addressModel];
    NSString *insertSql = @"INSERT INTO T_UserAddress (userId, userAddressModel, selected, creatTime) VALUES (?, ?, ?, ?);";
    [self executeUpdate:insertSql withArgumentArray:@[@(userId), addressData, @1, @(creatTime)]];
}

- (void)deleteUserAddressWithAddressCreatTime:(NSInteger)creatTime userId:(NSInteger)userId {
    NSMutableArray<NSDictionary *> *getResult = [NSMutableArray array];
    NSString *getSql = @"SELECT * FROM T_UserAddress WHERE creatTime = ? and userId = ?;";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:getSql withArgumentsInArray:@[@(creatTime), @(userId)]];
        while (resultSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSUInteger colCount = resultSet.columnCount;
            for ( int i = 0; i < colCount; i++) {
                NSString *colName = [resultSet columnNameForIndex:i];
                id colValue = [resultSet objectForColumnIndex:i];
                dict[colName] = colValue;
            }
            [getResult addObject:dict.copy];
        }
    }];
    if (!getResult.count) {
        return;
    }
    
    BOOL isSelected = false;
    for ( int i = 0; i < getResult.count; i++) {
        NSDictionary *dict = getResult[i];
        NSInteger selected = [dict[@"selected"] integerValue];
        isSelected = selected;
    }
    if (isSelected) {
        NSString *newGetSql = @"SELECT * FROM T_UserAddress;";
        NSArray<NSDictionary *> *newGetResult = [self executeQueryResult:newGetSql];
        NSDictionary *firstDict = newGetResult.firstObject;
        NSString *changeSelectedSql = [NSString stringWithFormat:@"UPDATE T_UserAddress SET selected = 1 WHERE creatTime = %zd and userId = %zd;", firstDict[@"creatTime"], firstDict[@"userId"]];
        [self executeUpdate:changeSelectedSql withArgumentArray:nil];
    }
    
    NSString *deleteSql = @"DELETE FROM T_UserAddress WHERE creatTime = ? and userId = ?;";
    [self executeUpdate:deleteSql withArgumentArray:@[@(creatTime), @(userId)]];
}

- (void)setCurrentUserAddressWithAddressCreatTime:(NSInteger)creatTime userId:(NSInteger)userId {
    [self deletePickUpWithUserId:userId];
    [self cancelCurrentSelectedUserAddressWithUserId:userId];
    
    NSString *setSql = @"UPDATE T_UserAddress SET selected = 1 WHERE creatTime = ? and userId = ?;";
    [self executeUpdate:setSql withArgumentArray:@[@(creatTime), @(userId)]];
}

- (NSArray<NSDictionary *> *)getCurrentUserAddressWithUserId:(NSInteger)userId {
    NSString *getSql = [NSString stringWithFormat:@"SELECT * FROM T_UserAddress WHERE selected = 1 and userId = %zd;", userId];
    return [self getUserAddressWithSQL:getSql];
}

- (NSArray<NSDictionary *> *)getAllUserAddressWithUserId:(NSInteger)userId {
    NSString *getSql = [NSString stringWithFormat:@"SELECT * FROM T_UserAddress WHERE userId = %zd;", userId];
    return [self getUserAddressWithSQL:getSql];
}

- (void)cancelCurrentSelectedUserAddressWithUserId:(NSInteger)userId {
    NSString *cancelSelectedSql = @"UPDATE T_UserAddress SET selected = 0 WHERE selected = 1 and userId = ?;";
    [self executeUpdate:cancelSelectedSql withArgumentArray:@[@(userId)]];
}

- (NSArray<NSDictionary *> *)getUserAddressWithSQL:(NSString *)sql {
    NSMutableArray *userAddress = [NSMutableArray array];
    NSArray *getResult = [self executeQueryResult:sql];
    for (NSDictionary *value in getResult) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:value];
        NSData *userAddressModelData = dict[@"userAddressModel"];
        YBZYAddressModel *userAddressModel = [NSKeyedUnarchiver unarchiveObjectWithData:userAddressModelData];
        dict[@"userAddressModel"] = userAddressModel;
        
        [userAddress addObject:dict.copy];
        NSLog(@"^^%@",dict);
    }
    return userAddress.copy;
}

#pragma mark - 自提点数据库接口

- (void)setPickUp:(YBZYPickUpModel *)pickUpModel withUserId:(NSInteger)userId {
    [self cancelCurrentSelectedUserAddressWithUserId:userId];
    [self deletePickUpWithUserId:userId];
    
    NSData *pickUpData = [NSKeyedArchiver archivedDataWithRootObject:pickUpModel];
    NSString *insertSql = @"INSERT INTO T_PickUp (userId, pickUpModel) VALUES (?, ?);";
    [self executeUpdate:insertSql withArgumentArray:@[@(userId), pickUpData]];
}

- (NSArray<NSDictionary *> *)getPickUpWithUserId:(NSInteger)userId {
    NSMutableArray *pickUp = [NSMutableArray array];
    
    NSString *getSql = [NSString stringWithFormat:@"SELECT * FROM T_PickUp WHERE userId = %zd;", userId];
    NSArray *getResult = [self executeQueryResult:getSql];
    for (NSDictionary *value in getResult) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:value];
        NSData *pickUpModelData = dict[@"pickUpModel"];
        YBZYPickUpModel *pickUpModel = [NSKeyedUnarchiver unarchiveObjectWithData:pickUpModelData];
        dict[@"pickUpModel"] = pickUpModel;
        
        [pickUp addObject:dict.copy];
        NSLog(@"^^%@",dict);
    }
    return pickUp.copy;
}

- (void)deletePickUpWithUserId:(NSInteger)userId {
    NSString *deleteSql = @"DELETE FROM T_PickUp WHERE userId = ?;";
    [self executeUpdate:deleteSql withArgumentArray:@[@(userId)]];
}

#pragma mark - 商品收藏数据库接口

- (void)addCollectionGood:(YBZYGoodModel *)goodModel withId:(NSInteger)goodId userId:(NSInteger)userId {
    NSData *goodData = [NSKeyedArchiver archivedDataWithRootObject:goodModel];
    NSString *insertSql = @"INSERT INTO T_CollectionGoods (id, userId, goodModel) VALUES (?, ?, ?);";
    [self executeUpdate:insertSql withArgumentArray:@[@(goodId), @(userId), goodData]];
}

- (void)deleteCollectionGoodWithId:(NSInteger)goodId userId:(NSInteger)userId {
    NSString *deleteSql = @"DELETE FROM T_CollectionGoods WHERE id = ? and userId = ?;";
    [self executeUpdate:deleteSql withArgumentArray:@[@(goodId), @(userId)]];
}

- (NSArray<NSDictionary *> *)getCollectionGoodsWithUserId:(NSInteger)userId {
    NSString *getSql = [NSString stringWithFormat:@"SELECT * FROM T_CollectionGoods WHERE userId = %zd;", userId];
    return [self getGoodsWithSQL:getSql];
}

@end
