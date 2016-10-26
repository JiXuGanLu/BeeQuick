//
//  YBZYCheckOutBillView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutBillView.h"
#import "YBZYCheckOutSubtitleCell.h"
#import "YBZYCheckOutPayMethodCell.h"
#import "YBZYCheckOutPromotionCell.h"
#import "YBZYCheckOutBalanceCell.h"
#import "YBZYCheckOutGoodListCell.h"
#import "YBZYCheckOutCostAmountCell.h"
#import "YBZYCheckOutPayPriceCell.h"

static NSString *subtitleCellId = @"subtitleCellId";
static NSString *payMethodCellId = @"payMethodCellId";
static NSString *promotionCellId = @"promotionCellId";
static NSString *balanceCellId = @"balanceCellId";
static NSString *goodListCellId = @"goodListCellId";
static NSString *costAmountCellId = @"costAmountCellId";
static NSString *payPriceCellId = @"payPriceCellId";

@interface YBZYCheckOutBillView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) YBZYCheckOutPayMethod selectedPayMethod;

@end

@implementation YBZYCheckOutBillView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = YBZYCommonBackgroundColor;
    self.selectedPayMethod = YBZYCheckOutPayMethodALiPay;
    [self registerNib];
}

- (void)registerNib {
    [self registerNib:[UINib nibWithNibName:@"YBZYCheckOutSubtitleCell" bundle:nil] forCellReuseIdentifier:subtitleCellId];
    [self registerNib:[UINib nibWithNibName:@"YBZYCheckOutPayMethodCell" bundle:nil] forCellReuseIdentifier:payMethodCellId];
    [self registerNib:[UINib nibWithNibName:@"YBZYCheckOutPromotionCell" bundle:nil] forCellReuseIdentifier:promotionCellId];
    [self registerNib:[UINib nibWithNibName:@"YBZYCheckOutBalanceCell" bundle:nil] forCellReuseIdentifier:balanceCellId];
    [self registerNib:[UINib nibWithNibName:@"YBZYCheckOutGoodListCell" bundle:nil] forCellReuseIdentifier:goodListCellId];
    [self registerNib:[UINib nibWithNibName:@"YBZYCheckOutCostAmountCell" bundle:nil] forCellReuseIdentifier:costAmountCellId];
    [self registerNib:[UINib nibWithNibName:@"YBZYCheckOutPayPriceCell" bundle:nil] forCellReuseIdentifier:payPriceCellId];
}

#pragma mark - 数据源和代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 2 + self.checkOutGoods.count;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 1 && indexPath.row == 0) {
        return 30;
    } else if (indexPath.section == 3 && indexPath.row == 1) {
        return 145;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YBZYCheckOutSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:subtitleCellId forIndexPath:indexPath];
            cell.subtitle = @"请选择支付方式";
            return cell;
        } else {
            YBZYCheckOutPayMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:payMethodCellId forIndexPath:indexPath];
            if (indexPath.row == 1) {
                cell.payMethod = YBZYCheckOutPayMethodALiPay;
                cell.payMethodSelected = self.selectedPayMethod == YBZYCheckOutPayMethodALiPay ? true : false;
            } else if (indexPath.row == 2) {
                cell.payMethod = YBZYCheckOutPayMethodWeChatPay;
                cell.payMethodSelected = self.selectedPayMethod == YBZYCheckOutPayMethodWeChatPay ? true : false;
            } else if (indexPath.row == 3) {
                cell.payMethod = YBZYCheckOutPayMethodQQPay;
                cell.payMethodSelected = self.selectedPayMethod == YBZYCheckOutPayMethodQQPay ? true : false;
            } else {
                cell.payMethod = YBZYCheckOutPayMethodCODPay;
                cell.payMethodSelected = self.selectedPayMethod == YBZYCheckOutPayMethodCODPay ? true : false;
            }
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row != 2) {
            YBZYCheckOutPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:promotionCellId forIndexPath:indexPath];
            if (indexPath.row == 0) {
                cell.promotionStyle = @"优惠券";
            } else {
                cell.promotionStyle = @"积分券";
            }
            return cell;
        } else {
            YBZYCheckOutBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:balanceCellId forIndexPath:indexPath];
            return cell;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            YBZYCheckOutSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:subtitleCellId forIndexPath:indexPath];
            cell.subtitle = @"精选商品";
            return cell;
        } else if (indexPath.row == [tableView numberOfRowsInSection:2] - 1) {
            YBZYCheckOutCostAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:costAmountCellId forIndexPath:indexPath];
            cell.costAmount = self.costAmount;
            return cell;
        } else {
            YBZYCheckOutGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:goodListCellId forIndexPath:indexPath];
            cell.goodInfo = self.checkOutGoods[indexPath.row - 1];
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            YBZYCheckOutSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:subtitleCellId forIndexPath:indexPath];
            cell.subtitle = @"费用明细";
            return cell;
        } else {
            YBZYCheckOutPayPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:payPriceCellId forIndexPath:indexPath];
            cell.costAmount = self.costAmount;
            cell.isFreightFree = self.isFreightFree;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row != 0) {
        YBZYCheckOutPayMethodCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.selectedPayMethod = cell.payMethod;
        [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
