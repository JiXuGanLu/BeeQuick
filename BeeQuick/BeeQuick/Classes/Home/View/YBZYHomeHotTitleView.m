//
//  YBZYHomeHotTitleView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeHotTitleView.h"

@implementation YBZYHomeHotTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"鲜蜂热卖";
    titleLabel.textColor = YBZYCommonLightTextColor;
    titleLabel.font = YBZYCommonMidFont;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.offset(8);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = YBZYCommonLightTextColor;
    [self addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.left.offset(8);
        make.right.equalTo(titleLabel.mas_left).offset(-5);
        make.height.offset(1);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = YBZYCommonLightTextColor;
    [self addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(5);
        make.right.offset(-8);
        make.height.offset(1);
    }];
}

@end
