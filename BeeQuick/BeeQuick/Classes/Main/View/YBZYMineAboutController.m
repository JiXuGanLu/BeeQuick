//
//  YBZYMineAboutController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/27.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineAboutController.h"

@interface YBZYMineAboutController ()

@end

@implementation YBZYMineAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationController.navigationBar.translucent = false;
    self.title = @"关于·YBZY爱鲜蜂";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *appIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2_about_logo"]];
    [self.view addSubview:appIcon];
    
    UILabel *versionLabel = [UILabel ybzy_labelWithText:@"V1.0 (仿官方3.50)" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    UILabel *gitLabel = [UILabel ybzy_labelWithText:@"https://github.com/JiXuGanLu/BeeQuick" andTextColor:YBZYCommonMidTextColor andFontSize:14];
    gitLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:gitLabel];
    
    UIButton *weChatTag = [UIButton buttonWithType:UIButtonTypeCustom];
    [weChatTag setImage:[[UIImage imageNamed:@"v2_about_wechat_logo"] ybzy_cornerImageWithSize:CGSizeMake(24, 20) fillColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [weChatTag setTitle:@" 微信: FreeSky-YQ" forState:UIControlStateNormal];
    [weChatTag setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
    weChatTag.titleLabel.font = YBZYCommonMidFont;
    weChatTag.userInteractionEnabled = false;
    [weChatTag sizeToFit];
    [self.view addSubview:weChatTag];
    
    [appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(50);
        make.height.width.offset(100);
    }];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(180);
        make.right.left.offset(0);
    }];
    
    [gitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.top.offset(204);
    }];
    
    [weChatTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.offset(-44);
    }];
}

@end
