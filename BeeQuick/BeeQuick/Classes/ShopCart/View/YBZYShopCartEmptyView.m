//
//  YBZYShopCartEmptyView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartEmptyView.h"

@implementation YBZYShopCartEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = YBZYCommonBackgroundColor;
    
    UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2_shop_empty"]];
    [self addSubview:emptyImageView];
    [emptyImageView sizeToFit];
    emptyImageView.centerX = self.centerX;
    emptyImageView.centerY = self.centerY - 60;
    
    UILabel *noticeLabel = [UILabel ybzy_labelWithText:@"穷逼，购物车毛都没有，快TM去买！" andTextColor:YBZYCommonMidTextColor andFontSize:16];
    [self addSubview:noticeLabel];
    [noticeLabel sizeToFit];
    noticeLabel.centerX = self.centerX;
    noticeLabel.centerY = self.centerY + 20;
    
    UIButton *goShoppingButton = [[UIButton alloc] init];
    [goShoppingButton setTitle:@"去剁手" forState:UIControlStateNormal];
    goShoppingButton.titleLabel.font = YBZYCommonBigFont;
    [goShoppingButton setTitleColor:YBZYCommonMidTextColor forState:UIControlStateNormal];
    goShoppingButton.frame = CGRectMake(0, 0, 150, 30);
    [goShoppingButton.layer setBorderColor:YBZYCommonMidTextColor.CGColor];
    [goShoppingButton.layer setBorderWidth:2.0];
    [goShoppingButton.layer setCornerRadius:8];
    [goShoppingButton.layer setMasksToBounds:true];
    [self addSubview:goShoppingButton];
    goShoppingButton.centerY = noticeLabel.centerY + 30;
    goShoppingButton.centerX = self.centerX;
    [goShoppingButton addTarget:self action:@selector(jumpToHome) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpToHome {
    [self.superViewController.navigationController.tabBarController setSelectedIndex:1];
}

@end
