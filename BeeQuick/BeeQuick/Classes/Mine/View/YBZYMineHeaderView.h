//
//  YBZYMineHeaderView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/26.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZYMineHeaderView : UIView

@property (nonatomic, copy) void(^aboutBlock)();
@property (nonatomic, copy) void(^collectionGoodBlock)();
@property (nonatomic, copy) void(^collectionStoreBlock)();


+ (instancetype)headerView;

@end
