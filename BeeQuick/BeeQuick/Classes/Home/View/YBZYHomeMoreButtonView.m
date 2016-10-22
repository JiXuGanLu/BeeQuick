//
//  YBZYHomeMoreButtonView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeMoreButtonView.h"

@implementation YBZYHomeMoreButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = YBZYCommonBackgroundColor;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 150, 50);
    [moreButton setTitle:@"点击查看全部商品" forState:UIControlStateNormal];
    [moreButton setTitleColor:YBZYCommonLightTextColor forState:UIControlStateNormal];
    moreButton.titleLabel.font = YBZYCommonBigFont;
    [moreButton setImage:[UIImage imageNamed:@"baidu_wallet_next_default_bottom"] forState:UIControlStateNormal];
    
    [moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -moreButton.imageView.width, 0, moreButton.imageView.width)];
    [moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, moreButton.titleLabel.width + 10, 0, -moreButton.titleLabel.width - 10)];
    
    [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)moreButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMoreButtonView:)]) {
        [self.delegate didClickMoreButtonView:self];
    }
}

@end
