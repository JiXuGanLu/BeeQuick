//
//  YBZYMineShopCollectionController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/30.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineShopCollectionController.h"

@interface YBZYMineShopCollectionController ()

@end

@implementation YBZYMineShopCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    self.title = @"店铺收藏";
    
    UIImageView *noStoreLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2_store_empty"]];
    [self.view addSubview:noStoreLogo];
    
    UILabel *noStoreLabel = [UILabel ybzy_labelWithText:@"没有收藏的店铺" andTextColor:YBZYCommonMidTextColor andFontSize:14];
    noStoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noStoreLabel];
    
    [noStoreLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
        make.width.height.offset(90);
    }];
    
    [noStoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(noStoreLogo.mas_bottom).offset(20);
    }];
}

@end
