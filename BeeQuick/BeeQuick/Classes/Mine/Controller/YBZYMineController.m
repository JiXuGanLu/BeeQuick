//
//  YBZYMineController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineController.h"
#import "YBZYMineHeaderView.h"
#import "UINavigationBar+YBZY.h"
#import "YBZYMineViewFlowLayout.h"
#import "YBZYMineViewTopCell.h"
#import "YBZYMineViewIconCell.h"
#import "YBZYMineViewWalletCell.h"

static NSString *topCellId = @"topCellId";
static NSString *iconCellId = @"iconCellId";
static NSString *walletCellId = @"walletCellId";

@interface YBZYMineController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) YBZYMineHeaderView *headerView;

@property (nonatomic, weak) UICollectionView *mineView;

@property (nonatomic, strong) NSArray<NSDictionary *> *orderItems;

@property (nonatomic, strong) NSArray<NSDictionary *> *walletItems;

@property (nonatomic, strong) NSArray<NSDictionary *> *bottomItems;

@end

@implementation YBZYMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar ybzy_reset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar ybzy_setBackgroundColor:[UIColor clearColor]];
}

- (void)setupUI {
    [self.navigationController.navigationBar ybzy_setBackgroundColor:[UIColor clearColor]];
    
    YBZYMineHeaderView *headerView = [YBZYMineHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, YBZYScreenWidth, 175);
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    YBZYMineViewFlowLayout *flowLayout = [[YBZYMineViewFlowLayout alloc] init];
    UICollectionView *mineView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 175, YBZYScreenWidth, self.view.height - 175) collectionViewLayout:flowLayout];
    mineView.delegate = self;
    mineView.dataSource = self;
    mineView.backgroundColor = YBZYCommonBackgroundColor;
    [self.view addSubview:mineView];
    mineView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.mineView = mineView;
    
    [mineView registerClass:[YBZYMineViewTopCell class] forCellWithReuseIdentifier:topCellId];
    [mineView registerClass:[YBZYMineViewIconCell class] forCellWithReuseIdentifier:iconCellId];
    [mineView registerClass:[YBZYMineViewWalletCell class] forCellWithReuseIdentifier:walletCellId];
}

- (NSArray<NSDictionary *> *)orderItems {
    return @[@{@"iconImageName" : @"icon_daifukuan", @"iconTitle" : @"待付款"},
             @{@"iconImageName" : @"icon_daishouhuo", @"iconTitle" : @"待收货"},
             @{@"iconImageName" : @"icon_daipingjia", @"iconTitle" : @"待评价"},
             @{@"iconImageName" : @"icon_tuikuan", @"iconTitle" : @"退款/售后"}];
}

- (NSArray<NSDictionary *> *)walletItems {
    return @[@{@"numberString" : @"¥0.00", @"walletType" : @"余额"},
             @{@"numberString" : @"0", @"walletType" : @"优惠券"},
             @{@"numberString" : @"0", @"walletType" : @"积分"}];
}

- (NSArray<NSDictionary *> *)bottomItems {
    return @[@{@"iconImageName" : @"Integral-mall", @"iconTitle" : @"积分商城"},
             @{@"iconImageName" : @"v2_my_address_icon", @"iconTitle" : @"收货地址"},
             @{@"iconImageName" : @"icon_message", @"iconTitle" : @"我的消息"},
             @{@"iconImageName" : @"v2_my_feedback_icon", @"iconTitle" : @"客服/反馈"},
             @{@"iconImageName" : @"v2_my_cooperate", @"iconTitle" : @"加盟合作"}];
}

#pragma mark - collectionView数据源和代理

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(YBZYScreenWidth, 44);
        }
        return CGSizeMake(YBZYScreenWidth / 4, 70);
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return CGSizeMake(YBZYScreenWidth, 44);
        }
        return CGSizeMake(YBZYScreenWidth / 3, 65);
    }
    return CGSizeMake(YBZYScreenWidth / 4, 90);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return 4;
    }
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YBZYMineViewTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellId forIndexPath:indexPath];
            cell.isAccessoryHidden = false;
            cell.title = @"我的订单";
            cell.subTitle = @"查看全部订单";
            return cell;
        }
        YBZYMineViewIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iconCellId forIndexPath:indexPath];
        cell.iconImageName = self.orderItems[indexPath.row - 1][@"iconImageName"];
        cell.iconTitle = self.orderItems[indexPath.row - 1][@"iconTitle"];
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            YBZYMineViewTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellId forIndexPath:indexPath];
            cell.isAccessoryHidden = true;
            cell.title = @"我的钱包";
            cell.subTitle = @"";
            return cell;
        }
        YBZYMineViewWalletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:walletCellId forIndexPath:indexPath];
        cell.numberString = self.walletItems[indexPath.row - 1][@"numberString"];
        cell.walletType = self.walletItems[indexPath.row - 1][@"walletType"];
        return cell;
    }
    YBZYMineViewIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iconCellId forIndexPath:indexPath];
    if (indexPath.row <= 4) {
        cell.iconImageName = self.bottomItems[indexPath.row][@"iconImageName"];
        cell.iconTitle = self.bottomItems[indexPath.row][@"iconTitle"];
    } else {
        cell.iconImageName = nil;
        cell.iconTitle = nil;
    }
    return cell;
}

@end
