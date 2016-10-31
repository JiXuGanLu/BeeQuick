//
//  YBZYGoodWebViewController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYGoodWebViewController.h"
#import "YBZYGoodWebViewToolBar.h"

@interface YBZYGoodWebViewController ()

@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, assign) NSInteger goodCount;
@property (nonatomic, weak) YBZYGoodWebViewToolBar *toolBar;

@end

@implementation YBZYGoodWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
    self.toolBar.isCollected = self.isCollected;
    self.toolBar.goodCount = self.goodCount;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = self.goodModel.name;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, YBZYScreenHeight - 64 - 44)];
    webView.scalesPageToFit = true;
    [self.view addSubview:webView];
    
    YBZYGoodWebViewToolBar *toolBar = [[YBZYGoodWebViewToolBar alloc] initWithFrame:CGRectMake(0, YBZYScreenHeight - 64 - 44, YBZYScreenWidth, 44)];
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    __weak typeof(self) weakSelf = self;
    toolBar.collectBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.isCollected) {
            [[YBZYSQLiteManager sharedManager] deleteCollectionGoodWithId:strongSelf.goodModel.id userId:YBZYUserId];
        } else {
            [[YBZYSQLiteManager sharedManager] addCollectionGood:strongSelf.goodModel withId:strongSelf.goodModel.id userId:YBZYUserId];
        }
        strongSelf.toolBar.isCollected = strongSelf.isCollected;
    };
    toolBar.addBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [[YBZYSQLiteManager sharedManager] addGood:strongSelf.goodModel withId:strongSelf.goodModel.id userId:YBZYUserId goodsType:strongSelf.goodModel.goods_type];
        strongSelf.toolBar.goodCount = strongSelf.goodCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
    };
    toolBar.reduceBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [[YBZYSQLiteManager sharedManager] reduceGoodWithId:strongSelf.goodModel.id userId:YBZYUserId];
        strongSelf.toolBar.goodCount = strongSelf.goodCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
    };
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.goodModel.urlString]];
    [webView loadRequest:request];
}

- (BOOL)isCollected {
    return [[YBZYSQLiteManager sharedManager] checkGoodBeenCollectedWithId:self.goodModel.id userId:YBZYUserId];
}

- (NSInteger)goodCount {
    NSArray<NSDictionary *> *goodData = [[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:self.goodModel.id userId:YBZYUserId];
    if (goodData.count) {
        return [[goodData firstObject][@"count"] integerValue];
    }
    return 0;
}

@end
