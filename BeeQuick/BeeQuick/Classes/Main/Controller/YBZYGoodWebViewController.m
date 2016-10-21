//
//  YBZYGoodWebViewController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYGoodWebViewController.h"

@interface YBZYGoodWebViewController ()

@end

@implementation YBZYGoodWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = self.goodModel.name;
    self.navigationController.navigationBar.translucent = false;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.scalesPageToFit = true;
    [self.view addSubview:webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.goodModel.urlString]];
    [webView loadRequest:request];
}

@end
