//
//  YBZYNewVersionController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYNewVersionController.h"
#import "YBZYNewVersionView.h"

@interface YBZYNewVersionController ()

@end

@implementation YBZYNewVersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    YBZYNewVersionView *newVV = [[YBZYNewVersionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:newVV];
}

@end
