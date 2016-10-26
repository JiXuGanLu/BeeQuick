//
//  YBZYShopCartView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartView.h"
#import "YBZYShopCartAddressCell.h"
#import "YBZYShopCartGoodCell.h"
#import "YBZYShopCartTipCell.h"
#import "YBZYShopCartCheckCell.h"
#import "YBZYShopCartDeliverTimeCell.h"
#import "YBZYShopCartGoodsListHeaderCell.h"

static NSString *noAddressCellID = @"noAddressCellID";
static NSString *pickUpCellID = @"pickUpCellID";
static NSString *addressCellID = @"addressCellID";
static NSString *goodsListHeaderCellID = @"goodsListHeaderCellID";
static NSString *deliverTimeCellID = @"deliverTimeCellID";
static NSString *specialGoodCellID = @"specialGoodCellID";
static NSString *normalGoodCellID = @"normalGoodCellID";
static NSString *tipCellID = @"tipCellID";
static NSString *checkCellID = @"checkCellID";

@interface YBZYShopCartView () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UITextField *pickerTextField;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *deliverDayArray;

@property (nonatomic, strong) NSArray<NSArray *> *totalTimeArray;

@property (nonatomic, strong) NSArray *deliverTimeArray;

@property (nonatomic, copy) NSString *selectedDeliverTime;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *bookingGoods;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *marketGoods;

@property (nonatomic, strong) NSMutableArray<NSArray *> *goodsArray;

@property (nonatomic, strong) NSMutableArray<NSArray *> *selectedGoodsArray;

@property (nonatomic, strong) NSArray<NSDictionary *> *currentUserAddress;

@property (nonatomic, strong) NSArray<NSDictionary *> *pickUp;

@property (nonatomic, assign) CGFloat marketPrice;

@property (nonatomic, assign) CGFloat bookingPrice;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *totalPriceArray;

@end

@implementation YBZYShopCartView

- (NSArray<NSDictionary *> *)pickUp {
    return [[YBZYSQLiteManager sharedManager] getPickUpWithUserId:YBZYUserId];
}

- (NSArray<NSDictionary *> *)currentUserAddress {
    return [[YBZYSQLiteManager sharedManager] getCurrentUserAddressWithUserId:YBZYUserId];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.estimatedRowHeight = 100;
    self.rowHeight = UITableViewAutomaticDimension;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH";
    NSString *currentHour = [fmt stringFromDate:currentDate];
    if (currentHour.integerValue >= 22) {
        self.selectedDeliverTime = @"明天 08:00-09:00";
    } else if (currentHour.integerValue >= 0 && currentHour.integerValue <= 7) {
        self.selectedDeliverTime = @"今天 08:00-09:00";
    } else {
        self.selectedDeliverTime = @"一小时送达（可预定）";
    }
    [self registerNib];
}

- (void)registerNib {
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartNoAddressCell" bundle:nil] forCellReuseIdentifier:noAddressCellID];
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartSelectPickUpCell" bundle:nil] forCellReuseIdentifier:pickUpCellID];
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartSelectAddressCell" bundle:nil] forCellReuseIdentifier:addressCellID];
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartGoodsListHeaderCell" bundle:nil] forCellReuseIdentifier:goodsListHeaderCellID];
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartDeliverTimeCell" bundle:nil] forCellReuseIdentifier:deliverTimeCellID];
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartSpecialGoodCell" bundle:nil] forCellReuseIdentifier:specialGoodCellID];
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartNormalGoodCell" bundle:nil] forCellReuseIdentifier:normalGoodCellID];
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartTipCell" bundle:nil] forCellReuseIdentifier:tipCellID];
    [self registerNib:[UINib nibWithNibName:@"YBZYShopCartCheckCell" bundle:nil] forCellReuseIdentifier:checkCellID];
}

#pragma mark - 获取商品数据

- (void)setGoodsList:(NSArray<NSDictionary *> *)goodsList {
    _goodsList = goodsList;
    
    self.marketGoods = [NSMutableArray array];
    self.bookingGoods = [NSMutableArray array];
    self.goodsArray = [NSMutableArray array];
    self.totalPriceArray = [NSMutableArray array];
    self.selectedGoodsArray = [NSMutableArray array];
    NSMutableArray *selectedBookingGoods = [NSMutableArray array];
    NSMutableArray *selectedMarketGoods = [NSMutableArray array];
    NSInteger totalCount = 0;
    
    self.marketPrice = 0.0;
    self.bookingPrice = 0.0;
    
    for (NSDictionary *dict in goodsList) {
        NSInteger goodsType = [dict[@"type"] integerValue];
        YBZYGoodModel *goodModel = dict[@"goodModel"];
        totalCount += [dict[@"count"] integerValue];
        if (goodsType) {
            [self.bookingGoods addObject:dict];
            self.bookingPrice += (goodModel.price * [dict[@"selected"] integerValue] * [dict[@"count"] integerValue]);
            if ([dict[@"selected"] integerValue]) {
                [selectedBookingGoods addObject:dict];
            }
        } else {
            [self.marketGoods addObject:dict];
            self.marketPrice += (goodModel.price * [dict[@"selected"] integerValue] * [dict[@"count"] integerValue]);
            if ([dict[@"selected"] integerValue]) {
                [selectedMarketGoods addObject:dict];
            }
        }
    }
    
    if (self.marketGoods.count) {
        [self.goodsArray addObject:self.marketGoods];
        [self.totalPriceArray addObject:@(self.marketPrice)];
        [self.selectedGoodsArray addObject:selectedMarketGoods];
    }
    if (self.bookingGoods.count) {
        [self.goodsArray addObject:self.bookingGoods];
        [self.totalPriceArray addObject:@(self.bookingPrice)];
        [self.selectedGoodsArray addObject:selectedBookingGoods];
    }
    
    if (self.goodsArray.count == 0) {
        if (self.noGoodsBlock) {
            self.noGoodsBlock();
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
}

#pragma mark - pickerview按键点击

- (void)doneButtonClick:(UIButton *)sender {
    //        [self beginUpdates];
    [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    //        [self endUpdates];
    [self.pickerTextField resignFirstResponder];
    self.pickerTextField = nil;
    self.pickerView = nil;
}

- (void)cancelButtonClick:(UIButton *)sender {
    [self.pickerTextField resignFirstResponder];
    self.pickerTextField = nil;
    self.pickerView = nil;
}

#pragma mark - tableview代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (1 + self.goodsArray.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.marketGoods.count ? self.marketGoods.count + 4 : self.bookingGoods.count + 3;
    } else {
        return self.bookingGoods.count + 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (self.pickUp.count) {
            cell = [tableView dequeueReusableCellWithIdentifier:pickUpCellID forIndexPath:indexPath];
        } else if (self.currentUserAddress.count) {
            cell = [tableView dequeueReusableCellWithIdentifier:addressCellID forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:noAddressCellID forIndexPath:indexPath];
        }
    } else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:goodsListHeaderCellID forIndexPath:indexPath];
            ((YBZYShopCartGoodsListHeaderCell *)cell).sourceName = self.marketGoods.count ? @"闪送超市" : @"新鲜预订";
            if (indexPath.section == 2) {
                ((YBZYShopCartGoodsListHeaderCell *)cell).sourceName = @"新鲜预订";
            }
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:deliverTimeCellID forIndexPath:indexPath];
            if (indexPath.section == 1) {
                if (self.pickUp.count) {
                    ((YBZYShopCartDeliverTimeCell *)cell).selectedDeliverTime = @"店铺当天营业时间内";
                } else {
                    ((YBZYShopCartDeliverTimeCell *)cell).selectedDeliverTime = self.marketGoods.count ? self.selectedDeliverTime : @"明天 10:00-20:00";
                }
                if (!self.marketGoods.count && self.bookingGoods.count) {
                    ((YBZYShopCartDeliverTimeCell *)cell).freightTip  = @"¥0起送，满69减免运费，不满¥69收取运费¥10";
                }
            } else {
                if (self.pickUp.count) {
                    ((YBZYShopCartDeliverTimeCell *)cell).selectedDeliverTime = @"店铺当天营业时间内";
                } else {
                    ((YBZYShopCartDeliverTimeCell *)cell).selectedDeliverTime = @"明天 10:00-20:00";
                }
                ((YBZYShopCartDeliverTimeCell *)cell).freightTip  = @"¥0起送，满69减免运费，不满¥69收取运费¥10";
            }
        } else if (indexPath.row > 1 && indexPath.row <= 1 + self.goodsArray[indexPath.section - 1].count) {
            YBZYGoodModel *good = self.goodsArray[indexPath.section - 1][indexPath.row - 2][@"goodModel"];
            if ([good.tag_ids isEqualToString:@"5"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:specialGoodCellID forIndexPath:indexPath];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:normalGoodCellID forIndexPath:indexPath];
            }
            ((YBZYShopCartGoodCell *)cell).good = self.goodsArray[indexPath.section - 1][indexPath.row - 2];
            ((YBZYShopCartGoodCell *)cell).detailButtonBlock = self.goodDetailButtonBlock;
            ((YBZYShopCartGoodCell *)cell).alertBlock = self.alertBlock;
            ((YBZYShopCartGoodCell *)cell).editButtonBlock = self.editButtonBlock;
            ((YBZYShopCartGoodCell *)cell).selectButtonBlock = self.selectButtonBlock;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:checkCellID forIndexPath:indexPath];
            ((YBZYShopCartCheckCell *)cell).isAllSelected = true;
            for (NSDictionary *dict in self.goodsArray[indexPath.section - 1]) {
                if ([dict[@"selected"] integerValue] == 0) {
                    ((YBZYShopCartCheckCell *)cell).isAllSelected = false;
                }
            }
            ((YBZYShopCartCheckCell *)cell).totalPrice = self.totalPriceArray[indexPath.section - 1];
            ((YBZYShopCartCheckCell *)cell).checkOutGoods = self.selectedGoodsArray[indexPath.section - 1];
            ((YBZYShopCartCheckCell *)cell).goodType = [self.goodsArray[indexPath.section - 1].firstObject[@"type"] integerValue];
            ((YBZYShopCartCheckCell *)cell).checkOutBlock = self.checkOutBlock;
            ((YBZYShopCartCheckCell *)cell).selectAllButtonBlock = self.selectAllButtonBlock;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:tipCellID forIndexPath:indexPath];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0 && indexPath.row == 1) {
        [self setPickerViewDataWithGoodsType:(indexPath.section - 1)];
        [self.pickerTextField becomeFirstResponder];
    }
}

#pragma mark - pickerview代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.deliverDayArray.count;
    }
    return self.deliverTimeArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.deliverDayArray[row];
    }
    return self.deliverTimeArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        
        self.deliverTimeArray = self.totalTimeArray[row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:false];
        self.selectedDeliverTime = [NSString stringWithFormat:@"%@ %@", self.deliverDayArray[row], self.deliverTimeArray[0]];
    } else {
        
        if ([self.deliverTimeArray[row] isEqualToString:@"10:00-20:00"]) {
            return;
        }
        NSInteger day = [pickerView selectedRowInComponent:0];
        self.selectedDeliverTime = [self.deliverTimeArray[row] isEqualToString:@"一小时送达"] ? @"一小时送达（可预定）" : [NSString stringWithFormat:@"%@ %@", self.deliverDayArray[day], self.deliverTimeArray[row]];
    }
}

#pragma mark - 计算pickerView加载的数据

- (void)setPickerViewDataWithGoodsType:(NSInteger)type {
    if (type) {
        
        self.deliverDayArray = @[@"明天"];
        self.totalTimeArray = @[@[@"10:00-20:00"]];
    } else {
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"HH";
        NSString *currentHour = [fmt stringFromDate:currentDate];
        
        
        NSArray *timeArray = @[@"08:00-09:00", @"09:00-10:00", @"10:00-11:00", @"11:00-12:00", @"12:00-13:00",@"13:00-14:00",@"14:00-15:00", @"15:00-16:00", @"16:00-17:00", @"17:00-18:00", @"18:00-19:00", @"19:00-20:00", @"20:00-21:00", @"21:00-22:00"];
        self.deliverDayArray = @[@"今天", @"明天", @"后天"];
        
        if (currentHour.integerValue >= 22) {
            self.deliverDayArray = @[@"明天", @"后天"];
            self.totalTimeArray = @[timeArray, timeArray];
        } else if (currentHour.integerValue <= 7) {
            self.totalTimeArray = @[timeArray, timeArray, timeArray];
        } else {
            NSMutableArray *subTimeArray = [NSMutableArray arrayWithArray:[timeArray subarrayWithRange:NSMakeRange(currentHour.integerValue - 7, 21 - currentHour.integerValue)]];
            [subTimeArray insertObject:@"一小时送达" atIndex:0];
            self.totalTimeArray = @[subTimeArray.copy, timeArray, timeArray];
        }
    }
    
    self.deliverTimeArray = self.totalTimeArray.firstObject;
}

#pragma mark - 懒加载

- (UITextField *)pickerTextField {
    if (!_pickerTextField) {
        UITextField *pickerTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        pickerTextField.inputView = self.pickerView;
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, 44)];
        toolBar.backgroundColor = [UIColor whiteColor];
        toolBar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClick:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClick:)];
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UILabel *titleLabel = [UILabel ybzy_labelWithText:@"啥时候约？" andTextColor:[UIColor lightGrayColor] andFontSize:16];
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, spaceButton, doneButton, nil]];
        [toolBar addSubview:titleLabel];
        [titleLabel sizeToFit];
        titleLabel.center = toolBar.center;
        pickerTextField.inputAccessoryView = toolBar;
        
        [self addSubview:pickerTextField];
        _pickerTextField = pickerTextField;
    }
    return _pickerTextField;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.backgroundColor = [UIColor colorWithWhite:0.99 alpha:0.7];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = true;
    }
    return _pickerView;
}

@end
