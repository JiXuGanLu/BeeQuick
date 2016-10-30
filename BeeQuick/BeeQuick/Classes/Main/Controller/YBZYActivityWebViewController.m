//
//  YBZYActivityWebViewController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYActivityWebViewController.h"

@interface YBZYActivityWebViewController ()

@end

@implementation YBZYActivityWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.scalesPageToFit = true;
    [self.view addSubview:webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [webView loadRequest:request];
}

@end
