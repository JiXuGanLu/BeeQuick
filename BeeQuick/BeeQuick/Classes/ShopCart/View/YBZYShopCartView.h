//
//  YBZYShopCartView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZYShopCartView : UITableView

@property (nonatomic, strong) NSArray<NSDictionary *> *goodsList;

@property (nonatomic, copy) void(^goodDetailButtonBlock)(YBZYGoodModel *goodModel);

@property (nonatomic, weak) UIViewController *superViewControl;

@property (nonatomic, copy) void(^noGoodsBlock)();

@end
