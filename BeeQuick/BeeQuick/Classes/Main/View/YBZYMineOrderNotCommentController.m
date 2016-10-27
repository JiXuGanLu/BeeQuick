//
//  YBZYMineOrderNotCommentController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/27.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineOrderNotCommentController.h"

@interface YBZYMineOrderNotCommentController ()

@property (nonatomic, weak) UIImageView *noOrderLogo;

@property (nonatomic, weak) UILabel *noOrderLabel;

@end

@implementation YBZYMineOrderNotCommentController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.noOrderLogo.hidden = false;
        self.noOrderLabel.hidden = false;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    
    UIImageView *noOrderLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2_order_empty"]];
    [self.view addSubview:noOrderLogo];
    self.noOrderLogo = noOrderLogo;
    
    UILabel *noOrderLabel = [UILabel ybzy_labelWithText:@"毛订单都没有" andTextColor:YBZYCommonMidTextColor andFontSize:14];
    noOrderLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noOrderLabel];
    self.noOrderLabel = noOrderLabel;
    
    [noOrderLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
        make.width.height.offset(90);
    }];
    
    [noOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(noOrderLogo.mas_bottom).offset(20);
    }];
    
    noOrderLogo.hidden = true;
    noOrderLabel.hidden = true;
}

@end
