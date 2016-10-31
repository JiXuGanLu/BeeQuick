//
//  YBZYCheckOutController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutController.h"
#import "YBZYCheckOutBillView.h"
#import "YBZYCheckOutConfirmView.h"

@interface YBZYCheckOutController ()

@property (nonatomic, assign) BOOL isFreightFree;
@property (nonatomic, assign) NSInteger freight;
@property (nonatomic, assign) CGFloat payPrice;

@end

@implementation YBZYCheckOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationController.navigationBar.translucent = false;
    self.title = @"结算付款";
    self.view.backgroundColor = [UIColor clearColor];
    
    YBZYCheckOutBillView *billView = [[YBZYCheckOutBillView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, self.view.height - 60 - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:billView];
    billView.costAmount = self.costAmount;
    billView.checkOutGoods = self.checkOutGoods;
    billView.freight = self.freight;
    billView.isFreightFree = self.isFreightFree;
    
    YBZYCheckOutConfirmView *confirmView = [[YBZYCheckOutConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height - 60 - 64, YBZYScreenWidth, 60)];
    [self.view addSubview:confirmView];
    confirmView.totalPrice = self.payPrice;
}

- (BOOL)isFreightFree {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH";
    NSString *currentHour = [fmt stringFromDate:currentDate];
    
    if (currentHour.integerValue >= 22 || self.goodType) {
        if (self.costAmount >= 69) {
            return true;
        } else {
            return false;
        }
    } else {
        if (self.costAmount >= 30) {
            return true;
        } else {
            return false;
        }
    }
}

- (NSInteger)freight {
    if (self.isPickUp) {
        return 0;
    } else {
        if (self.goodType) {
            return 10;
        }
        return 5;
    }
}

- (CGFloat)payPrice {
    return self.costAmount + self.freight * !self.isFreightFree;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
