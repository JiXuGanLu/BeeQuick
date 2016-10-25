//
//  YBZYShopCartController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartController.h"
#import "YBZYShopCartEmptyView.h"
#import "YBZYShopCartView.h"

@interface YBZYShopCartController ()

@property (nonatomic, weak) YBZYShopCartEmptyView *shopCartEmptyView;

@property (nonatomic, weak) YBZYShopCartView *shopCartView;

@property (nonatomic, strong) NSArray<NSDictionary *> *goodsList;

@end

@implementation YBZYShopCartController

- (NSArray<NSDictionary *> *)goodsList {
    return [[YBZYSQLiteManager sharedManager] getAllGoodsInShopCartWithUserId:YBZYUserId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationController.navigationBar.translucent = false;
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor clearColor];
    
    if (!self.goodsList.count) {
        self.shopCartEmptyView.hidden = false;
    } else {
        self.shopCartView.hidden = false;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.goodsList.count) {
        self.shopCartEmptyView.hidden = false;
        self.shopCartView.hidden = true;
    } else {
        self.shopCartView.hidden = false;
        self.shopCartEmptyView.hidden = true;
        self.shopCartView.goodsList = self.goodsList;
        [self.shopCartView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SVProgressHUD showWithStatus:@"正在验证商品信息"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - 懒加载

- (YBZYShopCartEmptyView *)shopCartEmptyView {
    if (!_shopCartEmptyView) {
        YBZYShopCartEmptyView *emptyView = [[YBZYShopCartEmptyView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:emptyView];
        _shopCartEmptyView = emptyView;
        _shopCartEmptyView.hidden = true;
        _shopCartEmptyView.superViewController = self;
    }
    return _shopCartEmptyView;
}

- (YBZYShopCartView *)shopCartView {
    if (!_shopCartView) {
        YBZYShopCartView *shopCartView = [[YBZYShopCartView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        shopCartView.goodsList = self.goodsList;
        shopCartView.superViewControl = self;
        __weak typeof(self) weakSelf = self;
        shopCartView.goodDetailButtonBlock = ^(YBZYGoodModel *goodModel){
            YBZYGoodWebViewController *webVC = [[YBZYGoodWebViewController alloc] init];
            webVC.goodModel = goodModel;
            [weakSelf.navigationController pushViewController:webVC animated:true];
        };
        shopCartView.noGoodsBlock = ^{
            weakSelf.shopCartEmptyView.hidden = false;
            weakSelf.shopCartView.hidden = true;
        };
        [self.view addSubview:shopCartView];
        shopCartView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        _shopCartView = shopCartView;
        _shopCartView.hidden = true;
    }
    return _shopCartView;
}

#pragma mark - 内存警告处理

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
