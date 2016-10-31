//
//  YBZYCheckOutPayPriceCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutPayPriceCell.h"

@interface YBZYCheckOutPayPriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *costAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@end

@implementation YBZYCheckOutPayPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCostAmount:(CGFloat)costAmount {
    _costAmount = costAmount;
    
    self.costAmountLabel.text = [NSString stringWithFormat:@"¥%.1lf", costAmount];
}

- (void)setIsFreightFree:(BOOL)isFreightFree {
    _isFreightFree = isFreightFree;
    
    if (isFreightFree) {
        self.freightDiscountLabel.text = [NSString stringWithFormat:@"¥%zd", self.freight];
    } else {
        self.freightDiscountLabel.text = @"¥0";
    }
}

- (void)setFreight:(NSInteger)freight {
    _freight = freight;
    
    self.freightLabel.text = [NSString stringWithFormat:@"¥%zd", freight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
