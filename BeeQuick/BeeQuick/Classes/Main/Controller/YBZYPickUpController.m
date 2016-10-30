//
//  YBZYPickUpController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYPickUpController.h"
#import "YBZYAddressLocateCell.h"
#import "YBZYAddressPickUpCell.h"

static NSString *locateCellId = @"locateCellId";
static NSString *pickUpCellId = @"pickUpCellId";

@interface YBZYPickUpController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, weak) UITableView *pickUpView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) NSString *locateString;

@property (nonatomic, strong) NSArray<YBZYPickUpModel *> *pickUps;

@end

@implementation YBZYPickUpController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadPickUpData];
    [self locate];
    [SVProgressHUD showWithStatus:@"定位中"];
}

- (void)setupUI {
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    
    UITableView *pickUpView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    pickUpView.delegate = self;
    pickUpView.dataSource = self;
    pickUpView.backgroundColor = YBZYCommonBackgroundColor;
    [self.view addSubview:pickUpView];
    self.pickUpView = pickUpView;
    [pickUpView registerClass:[YBZYAddressLocateCell class] forCellReuseIdentifier:locateCellId];
    [pickUpView registerClass:[YBZYAddressPickUpCell class] forCellReuseIdentifier:pickUpCellId];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.pickUps.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 25;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section) {
        UILabel *headerLabel = [UILabel ybzy_labelWithText:@"  抓不到请求接口, 就抓了几个返回的数据写死了" andTextColor:YBZYCommonMidTextColor andFontSize:14];
        [headerLabel sizeToFit];
        return headerLabel;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        YBZYAddressLocateCell *cell = [tableView dequeueReusableCellWithIdentifier:locateCellId forIndexPath:indexPath];
        cell.locateString = self.locateString;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    YBZYAddressPickUpCell *cell = [tableView dequeueReusableCellWithIdentifier:pickUpCellId forIndexPath:indexPath];
    cell.pickUpModel = self.pickUps[indexPath.row];
    YBZYPickUpModel *currentPickUp = [[[YBZYSQLiteManager sharedManager] getPickUpWithUserId:YBZYUserId] firstObject][@"pickUpModel"];
    if ([currentPickUp.id isEqualToString:cell.pickUpModel.id]) {
        cell.isCurrentPickUp = true;
    } else {
        cell.isCurrentPickUp = false;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [self.locationManager startUpdatingLocation];
        [SVProgressHUD showWithStatus:@"定位中"];
        return;
    }
    [[YBZYSQLiteManager sharedManager] setPickUp:self.pickUps[indexPath.row] withUserId:YBZYUserId];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - 定位及代理

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
    [self.pickUpView reloadData];
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
        [self.pickUpView reloadData];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - 数据

- (void)loadPickUpData {
    NSString *urlString = @"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickHomePickUp.json";
    [[YBZYHTTPSessionManager sharedSessionManager] requestMethod:YBZYHTTPMethodGet URLString:urlString parameters:nil completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSDictionary *data = response[@"data"];
        NSArray *dealers = data[@"dealers"];
        self.pickUps = [NSArray yy_modelArrayWithClass:[YBZYPickUpModel class] json:dealers];
        [self.pickUpView reloadData];
    }];
}

@end
