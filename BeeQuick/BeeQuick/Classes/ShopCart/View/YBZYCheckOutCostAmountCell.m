//
//  YBZYCheckOutCostAmountCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutCostAmountCell.h"

@interface YBZYCheckOutCostAmountCell ()

@property (weak, nonatomic) IBOutlet UILabel *costAmountLabel;

@end

@implementation YBZYCheckOutCostAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCostAmount:(CGFloat)costAmount {
    _costAmount = costAmount;
    
    self.costAmountLabel.text = [NSString stringWithFormat:@"合计:¥%.1lf", costAmount];
}

@end
