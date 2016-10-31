//
//  YBZYShopCartView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YBZYShopCartEditType) {
    YBZYShopCartEditTypeIncrease = 0,
    YBZYShopCartEditTypeReduce
};

typedef NS_ENUM(NSUInteger, YBZYShopCartSelectType) {
    YBZYShopCartSelectTypeSelect = 0,
    YBZYShopCartSelectTypeCancel
};

typedef NS_ENUM(NSUInteger, YBZYShopCartSelectAllType) {
    YBZYShopCartSelectAllTypeSelect = 0,
    YBZYShopCartSelectAllTypeCancel
};

@interface YBZYShopCartView : UITableView

@property (nonatomic, strong) NSArray<NSDictionary *> *goodsList;
@property (nonatomic, copy) void(^goodDetailButtonBlock)(YBZYGoodModel *goodModel);
@property (nonatomic, copy) void(^noGoodsBlock)();
@property (nonatomic, copy) void(^checkOutBlock)(NSArray<NSDictionary *> *selectedGoodList, CGFloat totalPrice, NSInteger goodType);
@property (nonatomic, copy) void(^alertBlock)(UIAlertController *alertController);
@property (nonatomic, copy) void(^editButtonBlock)(YBZYShopCartEditType editType, YBZYGoodModel *goodModel);
@property (nonatomic, copy) void(^selectButtonBlock)(YBZYShopCartSelectType type, YBZYGoodModel *goodModel);
@property (nonatomic, copy) void(^selectAllButtonBlock)(YBZYShopCartSelectAllType type, NSInteger goodType);
@property (nonatomic, copy) void(^addressBlock)(NSInteger index);
@property (nonatomic, strong) NSArray<NSDictionary *> *currentUserAddress;
@property (nonatomic, strong) NSArray<NSDictionary *> *pickUp;
@property (nonatomic, copy) void(^deleteBlock)(YBZYGoodModel *goodModel);

@end
