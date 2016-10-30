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
#import "YBZYCheckOutController.h"
#import "YBZYAddressSegmentedController.h"

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
    self.navigationController.navigationBar.translucent = false;
    
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
        shopCartView.showsVerticalScrollIndicator = false;
        shopCartView.showsHorizontalScrollIndicator = false;
        shopCartView.goodsList = self.goodsList;
        
        __weak typeof(self) weakSelf = self;
        shopCartView.goodDetailButtonBlock = ^(YBZYGoodModel *goodModel){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            YBZYGoodWebViewController *webVC = [[YBZYGoodWebViewController alloc] init];
            webVC.goodModel = goodModel;
            [strongSelf.navigationController pushViewController:webVC animated:true];
        };
        shopCartView.editButtonBlock = ^(YBZYShopCartEditType editType, YBZYGoodModel *goodModel){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (editType == YBZYShopCartEditTypeIncrease) {
                [[YBZYSQLiteManager sharedManager] addGood:goodModel withId:goodModel.id userId:YBZYUserId goodsType:goodModel.goods_type];
            } else {
                [[YBZYSQLiteManager sharedManager] reduceGoodWithId:goodModel.id userId:YBZYUserId];
            }
            strongSelf.shopCartView.goodsList = strongSelf.goodsList;
            [strongSelf.shopCartView reloadData];
        };
        shopCartView.selectButtonBlock = ^(YBZYShopCartSelectType type, YBZYGoodModel *goodModel){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (type == YBZYShopCartSelectTypeSelect) {
                [[YBZYSQLiteManager sharedManager] changeGoodCondition:1 inShopCartWithId:goodModel.id userId:YBZYUserId];
            } else {
                [[YBZYSQLiteManager sharedManager] changeGoodCondition:0 inShopCartWithId:goodModel.id userId:YBZYUserId];
            }
            strongSelf.shopCartView.goodsList = self.goodsList;
            [strongSelf.shopCartView reloadData];
        };
        shopCartView.alertBlock = ^(UIAlertController *alertController){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf presentViewController:alertController animated:true completion:nil];
        };
        shopCartView.selectAllButtonBlock = ^(YBZYShopCartSelectAllType type, NSInteger goodType){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (type == YBZYShopCartSelectAllTypeCancel) {
                [[YBZYSQLiteManager sharedManager] changeGoodCondition:0 inShopCartWithGoodsType:goodType userId:YBZYUserId];
            } else {
                [[YBZYSQLiteManager sharedManager] changeGoodCondition:1 inShopCartWithGoodsType:goodType userId:YBZYUserId];
            }
            strongSelf.shopCartView.goodsList = self.goodsList;
            [strongSelf.shopCartView reloadData];
        };
        shopCartView.noGoodsBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.shopCartEmptyView.hidden = false;
            strongSelf.shopCartView.hidden = true;
        };
        shopCartView.checkOutBlock = ^(NSArray<NSDictionary *> *selectedGoodList, CGFloat totalPrice){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (shopCartView.pickUp.count + shopCartView.currentUserAddress.count) {
                YBZYCheckOutController *checkOutController = [[YBZYCheckOutController alloc] init];
                checkOutController.checkOutGoods = selectedGoodList;
                checkOutController.costAmount = totalPrice;
                [strongSelf.navigationController pushViewController:checkOutController animated:true];
            } else {
                [SVProgressHUD showErrorWithStatus:@"请设置地址"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
        };
        shopCartView.addressBlock = ^(NSInteger index){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            YBZYAddressSegmentedController *asController = [[YBZYAddressSegmentedController alloc] init];
            asController.isAddressLocateHidden = true;
            asController.selectedIndex = index;
            [strongSelf.navigationController pushViewController:asController animated:true];
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
