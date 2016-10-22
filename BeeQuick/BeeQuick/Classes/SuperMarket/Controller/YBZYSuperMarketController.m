//
//  YBZYSuperMarketController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSuperMarketController.h"

@interface YBZYSuperMarketController ()

@end

@implementation YBZYSuperMarketController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = false;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(scanButtonClick) icon:@"icon_black_scancode" highlighticon:nil backgroundImage:[UIImage ybzy_imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(searchButtonClick) icon:@"icon_search" highlighticon:nil backgroundImage:[UIImage ybzy_imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
    
    UIButton *addressButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [addressButton setTitle:@"配送至: 新龙城居委会" forState:UIControlStateNormal];
    [addressButton.titleLabel setFont:YBZYCommonBigFont];
    [addressButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = addressButton;
}

- (void)scanButtonClick {
    
}

- (void)searchButtonClick {
    
}

- (void)addressButtonClick {
    
}

@end
