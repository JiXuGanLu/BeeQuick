//
//  YBZYCheckOutBillView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZYCheckOutBillView : UITableView

@property (nonatomic, strong) NSArray<NSDictionary *> *checkOutGoods;
@property (nonatomic, assign) CGFloat costAmount;
@property (nonatomic, assign) BOOL isFreightFree;
@property (nonatomic, assign) NSInteger freight;

@end
