//
//  YBZYScanController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/27.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYScanController.h"
#import "YBZYScanView.h"

@interface YBZYScanController () <YBZYScanViewDelegate>

@property (nonatomic, weak) YBZYScanView *scanView;

@end

@implementation YBZYScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    self.navigationController.navigationBar.translucent = false;
    self.title = @"二维码扫描";
    
    YBZYScanView *scanView = [[YBZYScanView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, YBZYScreenHeight - 64)];
    scanView.delegate = self;
    [self.view addSubview:scanView];
    self.scanView = scanView;
    
    [self.scanView startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scanView stopScan];
}

- (void)scanView:(YBZYScanView *)scanView scanSuccessWithCodeInfo:(NSString *)codeInfo {
    [SVProgressHUD showWithStatus:codeInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
