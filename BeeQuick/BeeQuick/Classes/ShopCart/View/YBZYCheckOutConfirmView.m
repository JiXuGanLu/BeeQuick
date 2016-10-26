//
//  YBZYCheckOutConfirmView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutConfirmView.h"

@interface YBZYCheckOutConfirmView ()

@property (nonatomic, weak) UILabel *totalPriceLabel;
@property (nonatomic, weak) UIButton *confirmButton;

@end

@implementation YBZYCheckOutConfirmView

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
    
    UIView *gapLine = [[UIView alloc] init];
    gapLine.backgroundColor = YBZYCommonLightTextColor;
    [self addSubview:gapLine];
    
    UILabel *label = [UILabel ybzy_labelWithText:@"应付金额:" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    [self addSubview:label];
    
    UILabel *totalPriceLabel = [UILabel ybzy_labelWithText:@"¥998.8" andTextColor:[UIColor redColor] andFontSize:20];
    [self addSubview:totalPriceLabel];
    self.totalPriceLabel = totalPriceLabel;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确认付款" forState:UIControlStateNormal];
    [confirmButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
    confirmButton.backgroundColor = YBZYCommonYellowColor;
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    self.confirmButton = confirmButton;
    
    [gapLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(1 / [UIScreen mainScreen].scale);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(16);
        make.width.offset(70);
    }];
    
    [totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(8);
        make.centerY.equalTo(self);
        make.width.offset(150);
    }];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.top.equalTo(gapLine.mas_bottom);
        make.width.offset(100);
    }];
}

- (void)setTotalPrice:(CGFloat)totalPrice {
    _totalPrice = totalPrice;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.1lf", totalPrice];
}

- (void)confirmButtonClick {
    [SVProgressHUD showWithStatus:@"别闹,一个模拟APP付啥款=.="];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
