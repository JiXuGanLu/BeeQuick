//
//  YBZYHomeTableView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZYHomeTableView : UITableView

@property (nonatomic, copy) void(^scrollBlock)(CGFloat offsetY);

@property (nonatomic, weak) UIViewController *superViewController;

@end
