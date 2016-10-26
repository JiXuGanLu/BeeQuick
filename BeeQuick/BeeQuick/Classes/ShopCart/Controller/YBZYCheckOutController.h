//
//  YBZYCheckOutController.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZYCheckOutController : UIViewController

@property (nonatomic, strong) NSArray<NSDictionary *> *checkOutGoods;
@property (nonatomic, assign) CGFloat costAmount;

@end
