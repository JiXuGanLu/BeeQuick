//
//  YBZYShopCartCheckCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartCheckCell.h"

@interface YBZYShopCartCheckCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkOutButton;

@end

@implementation YBZYShopCartCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.checkOutButton.backgroundColor = YBZYCommonYellowColor;
}

- (void)setIsAllSelected:(BOOL)isAllSelected {
    _isAllSelected = isAllSelected;
    self.selectAllButton.selected = isAllSelected;
}

- (IBAction)selectAllButtonClick:(UIButton *)sender {
    if (self.selectAllButtonBlock) {
        self.selectAllButtonBlock(self.selectAllButton.isSelected, self.goodType);
    }
}

- (void)setTotalPrice:(NSNumber *)totalPrice {
    _totalPrice = totalPrice;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"共¥ %.1lf", [totalPrice doubleValue]];
    
    if ([totalPrice doubleValue] <= 0) {
        self.checkOutButton.userInteractionEnabled = false;
        self.checkOutButton.backgroundColor = YBZYCommonLightTextColor;
        [self.checkOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.checkOutButton setTitle:@"满¥0起送" forState:UIControlStateNormal];
    } else {
        self.checkOutButton.userInteractionEnabled = true;
        self.checkOutButton.backgroundColor = YBZYCommonYellowColor;
        [self.checkOutButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
        [self.checkOutButton setTitle:@"选好了" forState:UIControlStateNormal];
    }
}

- (IBAction)checkOutButtonClick:(UIButton *)sender {
    if (self.checkOutBlock) {
        self.checkOutBlock(self.checkOutGoods, [self.totalPrice doubleValue]);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
