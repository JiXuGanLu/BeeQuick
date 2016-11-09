//
//  YBZYSuperMarketController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSuperMarketController.h"
#import "YBZYSuperMarketGoodCell.h"
#import "YBZYSuperMarketCategoryCell.h"
#import "YBZYSuperMarketSortViewFlowLayout.h"
#import "YBZYSuperMarketSortViewCell.h"
#import "YBZYSuperMarketSortHeaderView.h"
#import "YBZYSuperMarketProductModel.h"
#import "YBZYSuperMarketSortFooterView.h"
#import "YBZYScanController.h"
#import <objc/runtime.h>
#import "YBZYAddressSegmentedController.h"
#import "UINavigationBar+YBZY.h"

static NSString *goodCellId = @"goodCellId";
static NSString *categoryCellId = @"categoryCellId";
static NSString *sortCellId = @"sortCellId";
static NSString *sortHeaderId = @"sortHeaderId";
static NSString *sortFooterId = @"sortFooterId";
static NSString *animPictureViewKey = @"animPictureViewKey";

@interface YBZYSuperMarketController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, YBZYSuperMarketGoodCellDelegate, CAAnimationDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) UITableView *categoryView;
@property (nonatomic, weak) UIView *rightView;
@property (nonatomic, weak) UICollectionView *sortView;
@property (nonatomic, weak) UITableView *goodView;
@property (nonatomic, strong) NSArray<YBZYSuperMarketCategoryModel *> *categoryModels;
@property (nonatomic, strong) YBZYSuperMarketProductModel *productModel;
@property (nonatomic, strong) YBZYSuperMarketCategoryModel *selectedCategoryModel;
@property (nonatomic, assign) NSInteger selectedCid;
@property (nonatomic, strong) NSArray<YBZYGoodModel *> *selectedGoods;
@property (nonatomic, weak) YBZYSuperMarketSortHeaderView *sortHeaderView;
@property (nonatomic, copy) NSString *selectedCidName;
@property (nonatomic, assign) BOOL justSelectedCategory;
@property (nonatomic, assign) YBZYSQLOrderType selectedOrderType;
@property (nonatomic, assign) BOOL isCacheComplete;
@property (nonatomic, strong) YBZYAddressModel *currentAddressModel;
@property (nonatomic, strong) YBZYPickUpModel *currentPickUpModel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *locateString;
@property (nonatomic, weak) UIButton *addressButton;

@end

@implementation YBZYSuperMarketController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[YBZYSQLiteManager sharedManager] clearCachedSuperMarketGood];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToSelectedCategory:) name:YBZYPushSuperMarketNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locate) name:YBZYLocateNotification object:nil];
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    [self setupUI];
    [SVProgressHUD showWithStatus:@"正在加载"];
    [self loadSuperMarketData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar ybzy_setBackgroundColor:YBZYCommonYellowColor];
    if (self.currentAddressModel) {
        [self didSetCurrentAddress];
    }
    if (self.currentPickUpModel) {
        [self didSetCurrentPickUp];
    }
    [self didLocate];
    [self.goodView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupNavigationBar];
    if (self.currentAddressModel) {
        [self didSetCurrentAddress];
    }
    if (self.currentPickUpModel) {
        [self didSetCurrentPickUp];
    }
    [self didLocate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar ybzy_reset];
}

- (void)setupUI {
    [self setupNavigationBar];
    [self setupLeftView];
    [self setupRightView];
    
    self.categoryView.frame = CGRectMake(0, 0, 80, self.view.height);
    self.rightView.frame = CGRectMake(80, 0, YBZYScreenWidth - 80, self.view.height);
    self.sortView.frame = CGRectMake(0, 0, YBZYScreenWidth - 80, 44.5);
    self.goodView.frame = CGRectMake(0, 44.5, YBZYScreenWidth - 80, YBZYScreenHeight - 44.5);
    
    [self setupRefreshView];
    [self.categoryView reloadData];
    [self.sortView reloadData];
    [self.goodView reloadData];
}

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(scanButtonClick) icon:@"icon_black_scancode" highlighticon:nil backgroundImage:[UIImage ybzy_imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(searchButtonClick) icon:@"icon_search" highlighticon:nil backgroundImage:[UIImage ybzy_imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
    
    UIButton *addressButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [addressButton setTitle:@"    " forState:UIControlStateNormal];
    [addressButton.titleLabel setFont:YBZYCommonBigFont];
    [addressButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = addressButton;
    self.addressButton = addressButton;
}

- (void)setupLeftView {
    UITableView *categoryView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    categoryView.backgroundColor = YBZYCommonBackgroundColor;
    [categoryView registerClass:[YBZYSuperMarketCategoryCell class] forCellReuseIdentifier:categoryCellId];
    categoryView.delegate = self;
    categoryView.dataSource = self;
    categoryView.rowHeight = 44;
    [self.view addSubview:categoryView];
    self.categoryView = categoryView;
    categoryView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupRightView {
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = YBZYCommonBackgroundColor;
    [self.view addSubview:rightView];
    self.rightView = rightView;
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewDidPaned:)];
    [self.rightView addGestureRecognizer:panGes];
    panGes.delegate = self;
    
    
    UICollectionView *sortView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[YBZYSuperMarketSortViewFlowLayout alloc] init]];
    sortView.backgroundColor = [UIColor whiteColor];
    [sortView registerClass:[YBZYSuperMarketSortViewCell class] forCellWithReuseIdentifier:sortCellId];
    [sortView registerNib:[UINib nibWithNibName:@"YBZYSuperMarketSortHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sortHeaderId];
    [sortView registerNib:[UINib nibWithNibName:@"YBZYSuperMarketSortFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sortFooterId];
    sortView.delegate = self;
    sortView.dataSource = self;
    [self.rightView addSubview:sortView];
    self.sortView = sortView;
    
    UITableView *goodView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    goodView.backgroundColor = YBZYDarkBackgroundColor;
    [goodView registerClass:[YBZYSuperMarketGoodCell class] forCellReuseIdentifier:goodCellId];
    goodView.delegate = self;
    goodView.dataSource = self;
    goodView.rowHeight = 90;
    [self.rightView addSubview:goodView];
    self.goodView = goodView;
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookbottomdefault"]];
    bottomImageView.height = 150;
    goodView.tableFooterView = bottomImageView;
    goodView.tableFooterView.backgroundColor = YBZYDarkBackgroundColor;
    [goodView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
}

- (void)setupRefreshView {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(didPullDownToRefresh)];
    header.lastUpdatedTimeLabel.hidden = true;
    NSArray *refreshImage = @[[UIImage imageNamed:@"pushlistview_down"], [UIImage imageNamed:@"pushlistview_up"]];
    [header setImages:refreshImage forState:MJRefreshStateIdle];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setImages:refreshImage forState:MJRefreshStatePulling];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setImages:refreshImage forState:MJRefreshStateRefreshing];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    self.goodView.mj_header = header;
}

- (void)scanButtonClick {
    YBZYScanController *scanController = [[YBZYScanController alloc] init];
    [self.navigationController pushViewController:scanController animated:true];
}

- (void)searchButtonClick {
    [SVProgressHUD showWithStatus:@"官方搜索接口没抓到,没做这个页面"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)addressButtonClick {
    YBZYAddressSegmentedController *addressController = [[YBZYAddressSegmentedController alloc] init];
    if (self.currentPickUpModel) {
        addressController.selectedIndex = 1;
    }
    [self.navigationController pushViewController:addressController animated:true];
}

- (void)didSetCurrentAddress {
    [self.addressButton setTitle:[NSString stringWithFormat:@"配送到：%@", self.currentAddressModel.district] forState:UIControlStateNormal];
}

- (void)didSetCurrentPickUp {
    [self.addressButton setTitle:[NSString stringWithFormat:@"自提点：%@", self.currentPickUpModel.dealer_alias] forState:UIControlStateNormal];
}

- (void)didLocate {
    if (!self.currentAddressModel && !self.currentPickUpModel) {
        self.locateString = [[NSUserDefaults standardUserDefaults] objectForKey:YBZYLocateResultKey];
        if ([self.locateString isEqualToString:@"无法定位具体位置"] || [self.locateString isEqualToString:@"未打开定位服务"]) {
            [self.addressButton setTitle:self.locateString forState:UIControlStateNormal];
        } else if (self.locateString == nil) {
            [self.addressButton setTitle:@"定位中" forState:UIControlStateNormal];
        } else {
            [self.addressButton setTitle:[NSString stringWithFormat:@"配送到：%@", self.locateString] forState:UIControlStateNormal];
        }
    }
}

- (void)didPullDownToRefresh {
    if (self.categoryModels.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.goodView.mj_header endRefreshing];
        });
        return;
    }
    
    [self loadSuperMarketData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.categoryView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.categoryView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.categoryView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.categoryView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)rightViewDidPaned:(UIPanGestureRecognizer *)sender {
     switch (sender.state) {
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            return;
            break;
        default:
            break;
     }
    
    self.justSelectedCategory = false;
    
    CGPoint p = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    if (p.y < 0 && self.goodView.contentOffset.y >= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.goodView.frame = CGRectMake(0, 44.5, YBZYScreenWidth - 80, YBZYScreenHeight - 44.5);
        } completion:^(BOOL finished) {
            self.sortHeaderView.isScrollToTop = true;
            self.sortHeaderView.selectedCidName = self.selectedCidName;
        }];
    } else if (p.y >0 && self.goodView.contentOffset.y <= 0) {
        NSInteger rowCount = self.selectedCategoryModel.cids.count > 1 ? (self.selectedCategoryModel.cids.count + 2) / 3 : 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.goodView.frame = CGRectMake(0, 44.5 + 44 * rowCount, YBZYScreenWidth - 80, YBZYScreenHeight - 44.5 - 44 * rowCount);
        } completion:^(BOOL finished) {
            self.sortHeaderView.isScrollToTop = false;
        }];
    }
}

- (void)jumpToSelectedCategory:(NSNotification *)notification {
    NSInteger categoryId = [notification.userInfo[YBZYCategoryKey] integerValue];
    
    for ( int i = 0; i < self.categoryModels.count; i++) {
        YBZYSuperMarketCategoryModel *model = self.categoryModels[i];
        if (model.id == categoryId) {
            [self.categoryView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:false scrollPosition:UITableViewScrollPositionTop];
            self.selectedCategoryModel = model;
            return;
        }
    }
}

#pragma mark - table数据源和代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.justSelectedCategory) {
        self.justSelectedCategory = false;
        return;
    }
    
    if ([scrollView isEqual:self.goodView]) {
        CGFloat offsetY = scrollView.contentOffset.y;
        
        if (offsetY > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.goodView.frame = CGRectMake(0, 44.5, YBZYScreenWidth - 80, YBZYScreenHeight - 44.5);
            } completion:^(BOOL finished) {
                self.sortHeaderView.isScrollToTop = true;
                self.sortHeaderView.selectedCidName = self.selectedCidName;
            }];
        } else if (offsetY <= 0) {
            NSInteger rowCount = self.selectedCategoryModel.cids.count > 1 ? (self.selectedCategoryModel.cids.count + 2) / 3 : 0;
            [UIView animateWithDuration:0.2 animations:^{
                self.goodView.frame = CGRectMake(0, 44.5 + 44 * rowCount, YBZYScreenWidth - 80, YBZYScreenHeight - 44.5 - 44 * rowCount);
            } completion:^(BOOL finished) {
                self.sortHeaderView.isScrollToTop = false;
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryView) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryView) {
        return self.categoryModels.count;
    }
    return self.selectedGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryView) {
        YBZYSuperMarketCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellId forIndexPath:indexPath];
        cell.categoryModel = self.categoryModels[indexPath.row];
        return cell;
    }
    YBZYSuperMarketGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:goodCellId forIndexPath:indexPath];
    YBZYGoodModel *model = self.selectedGoods[indexPath.row];
    cell.goodModel = model;
    cell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:model.id userId:YBZYUserId].lastObject[@"count"] integerValue];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryView) {
        self.selectedCategoryModel = self.categoryModels[indexPath.row];
    }
}

- (void)setSelectedCategoryModel:(YBZYSuperMarketCategoryModel *)selectedCategoryModel {
    if (_selectedCategoryModel == selectedCategoryModel) {
        return;
    }
    
    _selectedCategoryModel = selectedCategoryModel;
    self.justSelectedCategory = true;
    self.selectedCid = 0;
    [self.sortView reloadData];
    [self.goodView reloadData];
    
    if (selectedCategoryModel.cids.count > 1) {
        [self.sortView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:false scrollPosition:UICollectionViewScrollPositionTop];
    }
    [self.goodView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
    self.selectedCidName = @"全部分类";
    self.sortHeaderView.isScrollToTop = false;
}

#pragma mark - goodCell点击代理

- (void)didClickPictureInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell {
    YBZYGoodWebViewController *goodWebVC = [[YBZYGoodWebViewController alloc] init];
    goodWebVC.goodModel = superMarketGoodCell.goodModel;
    [self.navigationController pushViewController:goodWebVC animated:true];
}

- (void)didClickAddButtonInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell {
    [[YBZYSQLiteManager sharedManager] addGood:superMarketGoodCell.goodModel withId:superMarketGoodCell.goodModel.id userId:YBZYUserId goodsType:superMarketGoodCell.goodModel.goods_type];
    
    superMarketGoodCell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:superMarketGoodCell.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
    });
    
    CGPoint startPoint = [superMarketGoodCell convertPoint:superMarketGoodCell.pictureView.center toView:self.view.window];
    CGPoint endPoint = [self.view.window convertPoint:CGPointMake(YBZYScreenWidth / 10 * 7, YBZYScreenHeight - 40) toView:self.view.window];
    CAKeyframeAnimation *anim = [[CAKeyframeAnimation alloc] init];
    anim.keyPath = @"position";
    anim.duration = 1;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(startPoint.x + 40, startPoint.y - 40)];
    anim.path = path.CGPath;
    anim.delegate = self;
    
    UIImageView *animPictureView = [[UIImageView alloc] initWithImage:superMarketGoodCell.pictureView.image];
    animPictureView.frame = superMarketGoodCell.pictureView.frame;
    CGAffineTransform transform = superMarketGoodCell.pictureView.transform;
    animPictureView.transform = transform;
    [self.view.window addSubview:animPictureView];
    [anim setValue:animPictureView forKey:animPictureViewKey];
    [animPictureView.layer addAnimation:anim forKey:nil];
    transform = CGAffineTransformMakeScale(.1, .1);
    transform = CGAffineTransformRotate(transform, M_PI_4 + M_PI_4 / 2);
    [UIView animateWithDuration:anim.duration animations:^{
        animPictureView.alpha = .5;
        animPictureView.transform = transform;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UIView *view = [anim valueForKey:animPictureViewKey];
    [view removeFromSuperview];
}

- (void)didClickReduceButtonInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell {
    [[YBZYSQLiteManager sharedManager] reduceGoodWithId:superMarketGoodCell.goodModel.id userId:YBZYUserId];
    superMarketGoodCell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:superMarketGoodCell.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
}

#pragma mark - collection数据源和代理

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YBZYSuperMarketSortHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sortHeaderId forIndexPath:indexPath];
        
        __weak typeof(self) weakSelf = self;
        headerView.coverViewBlock = ^(){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSInteger rowCount = strongSelf.selectedCategoryModel.cids.count > 1 ? (strongSelf.selectedCategoryModel.cids.count + 2) / 3 : 0;
            [UIView animateWithDuration:0.2 animations:^{
                strongSelf.goodView.frame = CGRectMake(0, 44.5 + 44 * rowCount, YBZYScreenWidth - 80, YBZYScreenHeight - 44.5 - 44 * rowCount);
            } completion:^(BOOL finished) {
                strongSelf.sortHeaderView.isScrollToTop = false;
            }];
        };
        headerView.changeSortBlock = ^(NSString *sortType){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([sortType isEqualToString:@"综合排序"] || [sortType isEqualToString:@"按销量"]) {
                strongSelf.selectedOrderType = YBZYSQLOrderTypeNormal;
            } else if ([sortType isEqualToString:@"价格最低"]) {
                strongSelf.selectedOrderType = YBZYSQLOrderTypePriceAscending;
            } else {
                strongSelf.selectedOrderType = YBZYSQLOrderTypePriceDescending;
            }
            [strongSelf.goodView reloadData];
        };
        
        self.sortHeaderView = headerView;
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        YBZYSuperMarketSortFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sortFooterId forIndexPath:indexPath];
        return footerView;
    }
    return nil;    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedCategoryModel.cids.count <= 1) {
        self.sortView.frame = CGRectMake(0, 0, YBZYScreenWidth - 80, 44.5);
        self.goodView.frame = CGRectMake(0, 44.5, YBZYScreenWidth - 80, self.view.height - 44.5);
        return 0;
    } else {
        NSInteger rowCount = (self.selectedCategoryModel.cids.count + 2) / 3;
        self.sortView.frame = CGRectMake(0, 0, YBZYScreenWidth - 80, 44.5 + 44 * rowCount);
        self.goodView.frame = CGRectMake(0, 44.5 + 44 * rowCount, YBZYScreenWidth - 80, YBZYScreenHeight - 44.5 - 44 * rowCount);
        return self.selectedCategoryModel.cids.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYSuperMarketSortViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sortCellId forIndexPath:indexPath];
    cell.cidModel = self.selectedCategoryModel.cids[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCidName = self.selectedCategoryModel.cids[indexPath.row].name;
    self.selectedCid = self.selectedCategoryModel.cids[indexPath.row].id;
    [self.goodView reloadData];
}

#pragma mark - 网络请求

- (void)loadSuperMarketData {
    NSString *urlString = @"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickSuperMarketGoodsList.json";
    
    [[YBZYHTTPSessionManager sharedSessionManager] requestMethod:YBZYHTTPMethodGet URLString:urlString parameters:nil completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"网络错误,请下拉刷新"];
            [self.goodView.mj_header endRefreshing];
            return;
        }
        
        [self.goodView.mj_header endRefreshing];
        
        NSDictionary *data = response[@"data"];
        self.categoryModels = [NSArray yy_modelArrayWithClass:[YBZYSuperMarketCategoryModel class] json:data[@"categories"]];
        self.productModel = [YBZYSuperMarketProductModel yy_modelWithDictionary:data[@"products"]];
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            [self cacheSuperMarketProductData:[YBZYSuperMarketProductModel yy_modelWithDictionary:data[@"products"]]];
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
        
        [self.categoryView reloadData];
        [self.categoryView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:false scrollPosition:UITableViewScrollPositionTop];
        self.selectedOrderType = YBZYSQLOrderTypeNormal;
        self.selectedCategoryModel = [self.categoryModels firstObject];
        [SVProgressHUD dismiss];
    }];
}

- (void)cacheSuperMarketProductData:(YBZYSuperMarketProductModel *)productModel {
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([YBZYSuperMarketProductModel class], &count);
    
    for ( int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cPropertyName = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        NSArray<YBZYGoodModel *> *goodList = [productModel valueForKey:propertyName];
        
        for (YBZYGoodModel *goodModel in goodList) {
            [[YBZYSQLiteManager sharedManager] cacheSuperMarketGood:goodModel];
        }
    }
    free(propertyList);
    
    self.isCacheComplete = true;
}

#pragma mark - 选中分类的商品

- (NSArray<YBZYGoodModel *> *)selectedGoods {
    if (self.selectedCategoryModel) {
        if (self.isCacheComplete) {
            NSInteger categoryId = self.selectedCategoryModel.id;
            NSArray<NSDictionary *> *loadResult = [[YBZYSQLiteManager sharedManager] loadSuperMarketGoodWithCategoryId:categoryId childCid:self.selectedCid orderBy:self.selectedOrderType];
            
            NSMutableArray *selectedGoods = [NSMutableArray array];
            for (NSDictionary *dict in loadResult) {
                YBZYGoodModel *goodModel = dict[@"goodModel"];
                [selectedGoods addObject:goodModel];
            }
            return selectedGoods.copy;
        } else {
            NSString *key = self.selectedCategoryModel.nameKey;
            NSArray *selectedGoods = [self.productModel valueForKey:key];
            return selectedGoods;
        }
    }
    return nil;
}

#pragma mark - 定位

- (void)locate {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.locateString = @"未打开定位服务";
    
    [[NSUserDefaults standardUserDefaults] setObject:self.locateString forKey:YBZYLocateResultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self didLocate];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        //打开设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.locateString = placeMark.thoroughfare;
            if (!self.locateString) {
                self.locateString = @"无法定位具体位置";
            }
            NSLog(@"%@", self.locateString);//城市名
            NSLog(@"%@", placeMark.name);  //全长度地址
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
            self.locateString = @"无法定位具体位置";
        } else if (error) {
            NSLog(@"location error: %@ ", error);
            self.locateString = @"无法定位具体位置";
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.locateString forKey:YBZYLocateResultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self didLocate];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - 地址数据

- (YBZYAddressModel *)currentAddressModel {
    return [[[YBZYSQLiteManager sharedManager] getCurrentUserAddressWithUserId:YBZYUserId] firstObject][@"userAddressModel"];
}

- (YBZYPickUpModel *)currentPickUpModel {
    return [[[YBZYSQLiteManager sharedManager] getPickUpWithUserId:YBZYUserId] firstObject][@"pickUpModel"];
}

- (void)dealloc {
    [[YBZYSQLiteManager sharedManager] clearCachedSuperMarketGood];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
