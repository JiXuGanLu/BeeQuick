//
//  YBZYNavigationController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYNavigationController.h"

@interface YBZYNavigationController ()

@end

@implementation YBZYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:YBZYCommonYellowColor];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = true;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.navigationBar.translucent = true;
    return [super popViewControllerAnimated:animated];
}

@end
