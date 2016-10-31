//
//  YBZYHomeController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeController.h"
#import "UINavigationBar+YBZY.h"
#import "YBZYHomeTableView.h"
#import "YBZYScanController.h"
#import "YBZYAddressSegmentedController.h"

static NSString *addGoodAnimKey = @"addGoodAnimKey";

@interface YBZYHomeController () <YBZYHomeCategoryCellDelegate, YBZYHomeCategoryGoodViewDelegate, YBZYPushViewDelegate, YBZYHomeHotGoodViewCellDelegate, YBZYHomeMoreButtonViewDelegate, CAAnimationDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) YBZYHomeTableView *homeTableView;
@property (nonatomic, strong) UIImage *itemBackgroundImage;
@property (nonatomic, assign) CGFloat scrollOffsetY;
@property (nonatomic, weak) UIButton *addressButton;
@property (nonatomic, strong) YBZYAddressModel *currentAddressModel;
@property (nonatomic, strong) YBZYPickUpModel *currentPickUpModel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *locateString;

@end

@implementation YBZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    [self setupTableView];
    [self locate];
    [SVProgressHUD showWithStatus:@"定位中"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocate) name:YBZYLocateNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar ybzy_reset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarTitleView];
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
    if (self.currentAddressModel) {
        [self didSetCurrentAddress];
    }
    if (self.currentPickUpModel) {
        [self didSetCurrentPickUp];
    }
    [self didLocate];
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYHomeHotGoodViewRefreshNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNavigationBarTitleView];
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
    if (self.currentAddressModel) {
        [self didSetCurrentAddress];
    }
    if (self.currentPickUpModel) {
        [self didSetCurrentPickUp];
    }
    [self didLocate];
}

#pragma mark - 导航栏设置

- (void)setNavigationBarTitleView {
    UIButton *addressButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [addressButton setTitle:@"    " forState:UIControlStateNormal];
    [addressButton.titleLabel setFont:YBZYCommonBigFont];
    [addressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addressButton setBackgroundImage:[[UIImage ybzy_imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(200, 30)] ybzy_cornerImageWithSize:CGSizeMake(200, 30) fillColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = addressButton;
    self.addressButton = addressButton;
}

- (void)changeNavigationBarStyleWhenScroll:(CGFloat)offsetY {
    CGFloat alpha = offsetY / 100.0;
    [self.navigationController.navigationBar ybzy_setBackgroundColor:[YBZYCommonYellowColor colorWithAlphaComponent:alpha >= 0 ? alpha : 0]];
    
    if (alpha >= 1) {
        self.addressButton.alpha = 1;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(scanButtonClick) icon:@"icon_black_scancode" highlighticon:nil backgroundImage:[UIImage ybzy_imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(searchButtonClick) icon:@"icon_search" highlighticon:nil backgroundImage:[UIImage ybzy_imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
        [self.addressButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
        [self.addressButton setBackgroundImage:nil forState:UIControlStateNormal];
    } else if (alpha >= 0) {
        self.addressButton.alpha = 1;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(scanButtonClick) icon:@"icon_white_scancode" highlighticon:nil backgroundImage:self.itemBackgroundImage];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(searchButtonClick) icon:@"icon_search_white" highlighticon:nil backgroundImage:self.itemBackgroundImage];
        [self.addressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addressButton setBackgroundImage:[[UIImage ybzy_imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(200, 30)] ybzy_cornerImageWithSize:CGSizeMake(200, 30) fillColor:[UIColor clearColor]] forState:UIControlStateNormal];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.addressButton.alpha = 0;
    }
}

- (UIImage *)itemBackgroundImage {
    return [[UIImage ybzy_imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(30, 30)] ybzy_cornerImageWithSize:CGSizeMake(30, 30) fillColor:[UIColor clearColor]];
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

#pragma mark - tableview

- (void)setupTableView {
    YBZYHomeTableView *tableView = [[YBZYHomeTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.superViewController = self;
    [self.view addSubview:tableView];
    tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    __weak typeof(self) weakSelf = self;
    tableView.scrollBlock = ^(CGFloat offsetY) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.scrollOffsetY = offsetY;
        [strongSelf changeNavigationBarStyleWhenScroll:offsetY];
    };
}

#pragma mark - 子视图代理

- (void)pushAssignedViewcontroller:(UIViewController *)assignedViewcontroller {
    [self.navigationController pushViewController:assignedViewcontroller animated:true];
}

- (void)didClickPictureInHomeCategoryCell:(YBZYHomeCategoryCell *)cell {
    YBZYActivityWebViewController *actWebVC = [[YBZYActivityWebViewController alloc] init];
    actWebVC.urlString = cell.categoryModel.activity.urlString;
    actWebVC.title = cell.categoryModel.activity.name;
    
    [self.navigationController pushViewController:actWebVC animated:true];
}

- (void)didClickMoreButtonInHomeCategoryCell:(YBZYHomeCategoryCell *)cell {
    [self.navigationController.tabBarController setSelectedIndex:1];
    
    static NSUInteger firstPushFLag = 1;
    if (firstPushFLag) {
        firstPushFLag = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:YBZYPushSuperMarketNotification object:nil userInfo:@{YBZYCategoryKey :cell.categoryModel.category_detail.category_id}];
        });
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYPushSuperMarketNotification object:nil userInfo:@{YBZYCategoryKey :cell.categoryModel.category_detail.category_id}];
    }
}

- (void)didClickGoodImageInHomeCategoryGoodView:(YBZYHomeCategoryGoodView *)homeCategoryGoodView {
    YBZYGoodWebViewController *goodWebVC = [[YBZYGoodWebViewController alloc] init];
    goodWebVC.goodModel = homeCategoryGoodView.goodModel;
    
    [self.navigationController pushViewController:goodWebVC animated:true];
}

- (void)didClickAddButtonInHomeCategoryGoodView:(YBZYHomeCategoryGoodView *)homeCategoryGoodView {
    [[YBZYSQLiteManager sharedManager] addGood:homeCategoryGoodView.goodModel withId:homeCategoryGoodView.goodModel.id userId:YBZYUserId goodsType:homeCategoryGoodView.goodModel.goods_type];
    homeCategoryGoodView.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:homeCategoryGoodView.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
    });
    
    [self animationWhenAddGoodInView:homeCategoryGoodView withImageView:homeCategoryGoodView.imageView];
}

- (void)didClickPictureInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell {
    YBZYGoodWebViewController *goodWebVC = [[YBZYGoodWebViewController alloc] init];
    goodWebVC.goodModel = homeHotGoodViewCell.goodModel;
    
    [self.navigationController pushViewController:goodWebVC animated:true];
}

- (void)didClickAddButtonInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell {
    [[YBZYSQLiteManager sharedManager] addGood:homeHotGoodViewCell.goodModel withId:homeHotGoodViewCell.goodModel.id userId:YBZYUserId goodsType:homeHotGoodViewCell.goodModel.goods_type];
    
    homeHotGoodViewCell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:homeHotGoodViewCell.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
    });
    
    [self animationWhenAddGoodInView:homeHotGoodViewCell withImageView:homeHotGoodViewCell.pictureView];
}

- (void)didClickReduceButtonInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell {
    [[YBZYSQLiteManager sharedManager] reduceGoodWithId:homeHotGoodViewCell.goodModel.id userId:YBZYUserId];
    homeHotGoodViewCell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:homeHotGoodViewCell.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
}

- (void)didClickMoreButtonView:(YBZYHomeMoreButtonView *)moreButtonView {
    [self.navigationController.tabBarController setSelectedIndex:1];
}

#pragma mark - 动画

- (void)animationWhenAddGoodInView:(UIView *)view withImageView:(UIImageView *)imageView {
    CGPoint startPonit = [view convertPoint:imageView.center toView:self.view.window];
    CGPoint endPoint = [self.view.window convertPoint:CGPointMake(YBZYScreenWidth / 10 * 7, YBZYScreenHeight - 40) toView:self.view.window];
    CAKeyframeAnimation *anim = [[CAKeyframeAnimation alloc] init];
    anim.keyPath = @"position";
    anim.duration = 1;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPonit];
    [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(startPonit.x + 40, startPonit.y - 40)];
    anim.path = path.CGPath;
    anim.delegate = self;
    
    UIImageView *pictureView = [[UIImageView alloc] initWithImage:imageView.image];
    pictureView.frame = imageView.frame;
    CGAffineTransform transform = imageView.transform;
    pictureView.transform = transform;
    [self.view.window addSubview:pictureView];
    [anim setValue:pictureView forKey:addGoodAnimKey];
    [pictureView.layer addAnimation:anim forKey:nil];
    transform = CGAffineTransformMakeScale(.1, .1);
    transform = CGAffineTransformRotate(transform, M_PI_4 + M_PI_4 / 2);
    [UIView animateWithDuration:anim.duration animations:^{
        pictureView.alpha = .5;
        pictureView.transform = transform;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UIView *view = [anim valueForKey:addGoodAnimKey];
    [view removeFromSuperview];
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

- (void)startLocate {
    [SVProgressHUD showWithStatus:@"定位中"];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - 地址数据

- (YBZYAddressModel *)currentAddressModel {
    return [[[YBZYSQLiteManager sharedManager] getCurrentUserAddressWithUserId:YBZYUserId] firstObject][@"userAddressModel"];
}

- (YBZYPickUpModel *)currentPickUpModel {
    return [[[YBZYSQLiteManager sharedManager] getPickUpWithUserId:YBZYUserId] firstObject][@"pickUpModel"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
