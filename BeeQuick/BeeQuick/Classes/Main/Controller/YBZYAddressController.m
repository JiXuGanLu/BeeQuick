//
//  YBZYAddressController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressController.h"
#import "YBZYAddressAddView.h"
#import "YBZYAddressSelectCell.h"
#import "YBZYAddressLocateCell.h"
#import "YBZYAddressEditController.h"
#import "YBZYAddressEditController.h"

NSString * const YBZYLocateNotification = @"YBZYLocateNotification";

static NSString *locateCellId = @"locateCellId";
static NSString *selectCellId = @"selectCellId";

@interface YBZYAddressController () <UITableViewDelegate, UITableViewDataSource, YBZYAddressAddViewDelegate, YBZYAddressSelectCellDelegate>

@property (nonatomic, strong) NSArray<NSDictionary *> *addressData;

@property (nonatomic, weak) UITableView *addressView;

@end

@implementation YBZYAddressController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
    [self.addressView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    self.title = @"管理收货地址";
    
    UIView *emptyView = [[UIView alloc] init];
    emptyView.frame = self.view.bounds;
    emptyView.backgroundColor = YBZYCommonBackgroundColor;
    [self.view addSubview:emptyView];
    
    UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2_address_empty"]];
    [self.view addSubview:emptyImageView];
    emptyImageView.center = self.view.center;
    
    UITableView *addressView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, self.view.height - 64 - 44) style:UITableViewStyleGrouped];
    addressView.backgroundColor = YBZYCommonBackgroundColor;
    addressView.delegate = self;
    addressView.dataSource = self;
    [self.view addSubview:addressView];
    self.addressView = addressView;
    [addressView registerClass:[YBZYAddressLocateCell class] forCellReuseIdentifier:locateCellId];
    [addressView registerClass:[YBZYAddressSelectCell class] forCellReuseIdentifier:selectCellId];
    
    YBZYAddressAddView *addView = [[YBZYAddressAddView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 44, YBZYScreenWidth, 44)];
    addView.delegate = self;
    [self.view addSubview:addView];
}

#pragma mark - tableview数据源和代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isLoactionHidden) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isLoactionHidden || section == 1) {
        return self.addressData.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isLoactionHidden || indexPath.section == 1) {
        YBZYAddressSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCellId forIndexPath:indexPath];
        cell.addressModel = self.addressData[indexPath.row][@"userAddressModel"];
        cell.isCurrentAddress = [self.addressData[indexPath.row][@"selected"] integerValue];
        cell.delegate = self;
        return cell;
    }
    YBZYAddressLocateCell *cell = [tableView dequeueReusableCellWithIdentifier:locateCellId forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isLoactionHidden || indexPath.section == 1) {
        return 80;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isLoactionHidden || indexPath.section == 1) {
        YBZYAddressSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[YBZYSQLiteManager sharedManager] setCurrentUserAddressWithAddressCreatTime:cell.addressModel.creatTime userId:YBZYUserId];
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [[YBZYSQLiteManager sharedManager] cancelCurrentSelectedUserAddressWithUserId:YBZYUserId];
        [[YBZYSQLiteManager sharedManager] deletePickUpWithUserId:YBZYUserId];
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYLocateNotification object:nil];
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark - 子视图代理

- (void)addressAddViewDidClickAddButton:(YBZYAddressAddView *)addView {
    YBZYAddressEditController *editController = [[YBZYAddressEditController alloc] init];
    [self.navigationController pushViewController:editController animated:true];
}

- (void)addressSelectCell:(YBZYAddressSelectCell *)cell didClickEditButtonToEditAddress:(YBZYAddressModel *)addressModel {
    YBZYAddressEditController *editController = [[YBZYAddressEditController alloc] init];
    editController.addressModel = addressModel;
    [self.navigationController pushViewController:editController animated:true];
}

#pragma mark - 数据库方法

- (NSArray<NSDictionary *> *)addressData {
    NSArray<NSDictionary *> *addressData = [[YBZYSQLiteManager sharedManager] getAllUserAddressWithUserId:YBZYUserId];
    if (addressData.count) {
        self.addressView.backgroundColor = YBZYCommonBackgroundColor;
    } else {
        self.addressView.backgroundColor = [UIColor clearColor];
    }
    return addressData;
}

@end
