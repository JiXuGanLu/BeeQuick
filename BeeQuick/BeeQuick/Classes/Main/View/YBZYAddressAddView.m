//
//  YBZYAddressAddView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressAddView.h"

@implementation YBZYAddressAddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundColor:YBZYCommonYellowColor];
    [addButton setTitle:@"+  新增地址" forState:UIControlStateNormal];
    addButton.titleLabel.font = YBZYCommonBigFont;
    [addButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
    [addButton.layer setCornerRadius:4];
    addButton.clipsToBounds = true;
    [self addSubview:addButton];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *gapLine = [[UIView alloc] init];
    gapLine.backgroundColor = YBZYDarkBackgroundColor;
    [self addSubview:gapLine];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.offset(200);
        make.height.offset(36);
    }];
    
    [gapLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.offset(0);
        make.height.offset(1);
    }];
}

- (void)addButtonClick {
    if ([self.delegate respondsToSelector:@selector(addressAddViewDidClickAddButton:)]) {
        [self.delegate addressAddViewDidClickAddButton:self];
    }
}

@end
