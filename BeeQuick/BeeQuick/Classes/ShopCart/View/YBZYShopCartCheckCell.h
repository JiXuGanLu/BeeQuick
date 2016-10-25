//
//  YBZYShopCartCheckCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YBZYShopCartSelectAllType) {
    YBZYShopCartSelectAllTypeSelect = 0,
    YBZYShopCartSelectAllTypeCancel
};

@interface YBZYShopCartCheckCell : UITableViewCell

@property (nonatomic, assign) BOOL isAllSelected;

@property (nonatomic, copy) void(^selectAllButtonBlock)(YBZYShopCartSelectAllType type);

@property (nonatomic, strong) NSNumber *totalPrice;

@end
