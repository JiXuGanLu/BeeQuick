//
//  YBZYShopCartCheckCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBZYShopCartView.h"

@interface YBZYShopCartCheckCell : UITableViewCell

@property (nonatomic, assign) BOOL isAllSelected;

@property (nonatomic, copy) void(^selectAllButtonBlock)(YBZYShopCartSelectAllType type, NSInteger goodType);

@property (nonatomic, strong) NSNumber *totalPrice;

@property (nonatomic, strong) NSArray<NSDictionary *> *checkOutGoods;

@property (nonatomic, copy) void(^checkOutBlock)(NSArray<NSDictionary *> *checkOutGoods, CGFloat totalPrice, NSInteger goodType);

@property (nonatomic, assign) NSInteger goodType;

@end
