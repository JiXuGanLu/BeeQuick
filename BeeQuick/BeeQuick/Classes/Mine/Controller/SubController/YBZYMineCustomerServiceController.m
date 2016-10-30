//
//  YBZYMineCustomerServiceController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/30.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineCustomerServiceController.h"

@interface YBZYMineCustomerServiceController ()

@end

@implementation YBZYMineCustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    self.title = @"客服/反馈";
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:@"http://www.sobot.com/chat/pc/index.html?sysNum=b30965e4b4114126a6a202aafce04fc5&partnerId=123&tel=123"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
