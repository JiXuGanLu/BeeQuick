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
    UILabel *label = [UILabel ybzy_labelWithText:@"应付金额:" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    [label sizeToFit];
    [self addSubview:label];
    label.x = 16;
    label.centerY = self.centerY;
    
    UILabel *totalPriceLabel = [UILabel ybzy_labelWithText:@"¥998.8" andTextColor:[UIColor redColor] andFontSize:16];
    totalPriceLabel.width = 150;
    totalPriceLabel.x = 90;
    totalPriceLabel.centerY = self.centerY;
    [self addSubview:totalPriceLabel];
    self.totalPriceLabel = totalPriceLabel;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确认付款" forState:UIControlStateNormal];
    [confirmButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
    confirmButton.backgroundColor = YBZYCommonYellowColor;
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    self.confirmButton = confirmButton;
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(60);
    }];
}

- (void)setTotalPrice:(CGFloat)totalPrice {
    _totalPrice = totalPrice;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.1lf", totalPrice];
}

- (void)confirmButtonClick {
    [SVProgressHUD showWithStatus:@"别闹,一个模拟APP付啥款=.="];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
