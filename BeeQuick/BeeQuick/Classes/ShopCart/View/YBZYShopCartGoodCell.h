//
//  YBZYShopCartGoodCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBZYShopCartView.h"

@interface YBZYShopCartGoodCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *good;

@property (nonatomic, copy) void(^editButtonBlock)(YBZYShopCartEditType editType, YBZYGoodModel *goodModel);

@property (nonatomic, copy) void(^detailButtonBlock)(YBZYGoodModel *goodModel);

@property (nonatomic, copy) void(^selectButtonBlock)(YBZYShopCartSelectType type, YBZYGoodModel *goodModel);

@property (nonatomic, copy) void(^alertBlock)(UIAlertController *alertController);

@end
