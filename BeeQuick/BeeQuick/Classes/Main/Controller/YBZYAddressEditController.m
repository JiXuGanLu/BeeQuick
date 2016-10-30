//
//  YBZYAddressEditController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressEditController.h"
#import "YBZYAddressEditFillCell.h"
#import "YBZYAddressEditGenderCell.h"
#import "YBZYAddressEditDeleteCell.h"

static NSString *fillCellId = @"fillCellId";
static NSString *genderCellId = @"genderCellId";
static NSString *deleteCellId = @"deleteCellId";

@interface YBZYAddressEditController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *telNumber;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *district;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, weak) UITableView *editView;

@property (nonatomic, strong) NSArray<YBZYCityGroupModel *> *cityGroups;

@end

@implementation YBZYAddressEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupUI {
    self.title = @"编辑地址";
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddress)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    UITableView *editView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    editView.delegate = self;
    editView.dataSource = self;
    editView.rowHeight = 44;
    editView.backgroundColor = YBZYCommonBackgroundColor;
    [self.view addSubview:editView];
    self.editView = editView;
    [editView registerClass:[YBZYAddressEditFillCell class] forCellReuseIdentifier:fillCellId];
    [editView registerClass:[YBZYAddressEditGenderCell class] forCellReuseIdentifier:genderCellId];
    [editView registerClass:[YBZYAddressEditDeleteCell class] forCellReuseIdentifier:deleteCellId];
}

- (void)setAddressModel:(YBZYAddressModel *)addressModel {
    _addressModel = addressModel;
    
    self.name = addressModel.name;
    self.gender = addressModel.gender;
    self.telNumber = addressModel.telNumber;
    self.city = addressModel.city;
    self.district = addressModel.district;
    self.detail = addressModel.detail;
}

- (void)saveAddress {
    if (self.name.length * self.gender.length * self.telNumber.length * self.city.length * self.district.length * self.detail.length) {
        if (![self checkTelNumber:self.telNumber]) {
            [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        if (self.addressModel) {
            self.addressModel.name = self.name;
            self.addressModel.gender = self.gender;
            self.addressModel.telNumber = self.telNumber;
            self.addressModel.city = self.city;
            self.addressModel.district = self.district;
            self.addressModel.detail = self.detail;
            
            [[YBZYSQLiteManager sharedManager] updateUserAddress:self.addressModel withAddressCreatTime:self.addressModel.creatTime userId:YBZYUserId];
        } else {
            YBZYAddressModel *model = [[YBZYAddressModel alloc] init];
            model.name = self.name;
            model.gender = self.gender;
            model.telNumber = self.telNumber;
            model.city = self.city;
            model.district = self.district;
            model.detail = self.detail;
            model.creatTime = [[NSDate date] timeIntervalSince1970];
            
            [[YBZYSQLiteManager sharedManager] addUserAddress:model withUserId:YBZYUserId creatTime:model.creatTime];
        }
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请完整填写地址信息"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

- (BOOL)checkTelNumber:(NSString *)telNumber {
    NSString *telFormat = @"^1+[3578]+\\d{9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telFormat];
    BOOL isMatch = [predicate evaluateWithObject:telNumber];
    return isMatch;
}

#pragma mark - tableView代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.addressModel) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return 1;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.section) {
        YBZYAddressEditDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:deleteCellId forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.row == 1) {
        YBZYAddressEditGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:genderCellId forIndexPath:indexPath];
        cell.originalGender = self.gender;
        cell.genderBlock = ^(NSString *gender){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.gender = gender;
        };
        return cell;
    }
    YBZYAddressEditFillCell *cell = [tableView dequeueReusableCellWithIdentifier:fillCellId forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.title = @"联系人";
        cell.placeHolderString = @"收货人姓名";
        cell.originalString = self.name;
        cell.isPickerInput = false;
        cell.keyboardType = UIKeyboardTypeDefault;
        cell.inputBlock = ^(NSString *inputString){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.name = inputString;
        };
    } else if (indexPath.row == 2) {
        cell.title = @"手机号码";
        cell.placeHolderString = @"联系您的号码";
        cell.originalString = self.telNumber;
        cell.isPickerInput = false;
        cell.keyboardType = UIKeyboardTypePhonePad;
        cell.inputBlock = ^(NSString *inputString){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.telNumber = inputString;
        };
    } else if (indexPath.row == 3) {
        cell.title = @"所在城市";
        cell.placeHolderString = @"请输入您所在的城市";
        cell.originalString = self.city;
        cell.cityGroups = self.cityGroups;
        cell.isPickerInput = true;
        cell.inputBlock = ^(NSString *inputString){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.city = inputString;
        };
    } else if (indexPath.row == 4) {
        cell.title = @"所在地区";
        cell.placeHolderString = @"请输入您所在的小区/大厦或学校";
        cell.originalString = self.district;
        cell.isPickerInput = false;
        cell.keyboardType = UIKeyboardTypeDefault;
        cell.inputBlock = ^(NSString *inputString){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.district = inputString;
        };
    } else {
        cell.title = @"详细地址";
        cell.placeHolderString = @"请输入街道号码门牌号等";
        cell.originalString = self.detail;
        cell.isPickerInput = false;
        cell.keyboardType = UIKeyboardTypeDefault;
        cell.inputBlock = ^(NSString *inputString){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.detail = inputString;
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"将要删除地址信息" message:@"请确认是否删除该地址信息?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [[YBZYSQLiteManager sharedManager] deleteUserAddressWithAddressCreatTime:self.addressModel.creatTime userId:YBZYUserId];
            [self.navigationController popViewControllerAnimated:true];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:ok];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (NSArray<YBZYCityGroupModel *> *)cityGroups {
    NSArray *cityGroupsPlist = [[NSArray alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil]];
    return [NSArray yy_modelArrayWithClass:[YBZYCityGroupModel class] json:cityGroupsPlist];
}

@end
