//
//  YBZYTabBarController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYTabBarController.h"
#import "YBZYTabBar.h"
#import "YBZYNavigationController.h"

@interface YBZYTabBarController ()

@property (nonatomic, weak) UIView *guideView;

@property (nonatomic, weak) UIViewController *homePage;

@property (nonatomic, weak) UIViewController *superMarketPage;

@property (nonatomic, weak) UIViewController *shopCartPage;

@property (nonatomic, weak) UIViewController *minePage;

@end

@implementation YBZYTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGuideView) name:YBZYIsNewLaunchNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeShopCartTag) name:YBZYAddOrReduceGoodNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YBZYTabBar *tabBar = [[YBZYTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [self addChildViewControllers];
    [self changeShopCartTag];
}

#pragma mark - 添加四个页面控制器
- (void)addChildViewControllers {
    UIViewController *homePage = [self loadTabBarItemAndNavigationControllerWithRootViewController:@"YBZYHomeController" andTitle:@"首页" andImageName:@"v2_home"];
    UIViewController *superMarketPage = [self loadTabBarItemAndNavigationControllerWithRootViewController:@"YBZYSuperMarketController" andTitle:@"闪送超市" andImageName:@"v2_order"];
    UIViewController *shopCartPage = [self loadTabBarItemAndNavigationControllerWithRootViewController:@"YBZYShopCartController" andTitle:@"购物车" andImageName:@"shopCart"];
    UIViewController *minePage = [self loadTabBarItemAndNavigationControllerWithRootViewController:@"YBZYMineController" andTitle:@"我的" andImageName:@"v2_my"];
    self.homePage = homePage;
    self.superMarketPage = superMarketPage;
    self.shopCartPage = shopCartPage;
    self.minePage = minePage;
    self.viewControllers = @[homePage,superMarketPage,shopCartPage,minePage];
}

- (UIViewController *)loadTabBarItemAndNavigationControllerWithRootViewController:(NSString *)className andTitle:(NSString *)title andImageName:(NSString *)imageName {
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selImage = [[UIImage imageNamed:[imageName stringByAppendingString:@"_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selImage];
    YBZYNavigationController *navC = [[YBZYNavigationController alloc] initWithRootViewController:viewController];
    return navC;
}

#pragma mark - 加载指导视图
- (void)loadGuideView {
    UIView *guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIImageView *guideImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homepage_guide"]];
    UIImageView *knownImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homepage_knownbtn"]];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGuideView)];
    knownImage.userInteractionEnabled = true;
    [knownImage addGestureRecognizer:tapGes];
    
    [guideView addSubview:guideImage];
    [guideView addSubview:knownImage];
    [guideImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(guideView);
        make.top.offset(25);
    }];
    [knownImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(guideView);
        make.bottom.offset(-80);
    }];
    
    [self.view addSubview:guideView];
    self.guideView = guideView;
}

- (void)removeGuideView {
    [self.guideView removeFromSuperview];
}

#pragma mark - 购物车标记变更

- (void)changeShopCartTag {
    NSArray *shopCartGoods = [[YBZYSQLiteManager sharedManager] getAllGoodsInShopCartWithUserId:YBZYUserId];
    
    NSInteger totalCount = 0;
    
    for (NSDictionary *dict in shopCartGoods) {
        totalCount += [dict[@"count"] integerValue];
    }
    
    if (totalCount) {
        self.shopCartPage.tabBarItem.badgeValue = @(totalCount).description;
    } else {
        self.shopCartPage.tabBarItem.badgeValue = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
