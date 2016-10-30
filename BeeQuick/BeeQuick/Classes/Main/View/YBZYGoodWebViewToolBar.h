//
//  YBZYGoodWebViewToolBar.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/30.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZYGoodWebViewToolBar : UIView

@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, assign) NSInteger goodCount;

@property (nonatomic, copy) void(^collectBlock)();
@property (nonatomic, copy) void(^addBlock)();
@property (nonatomic, copy) void(^reduceBlock)();

@end
