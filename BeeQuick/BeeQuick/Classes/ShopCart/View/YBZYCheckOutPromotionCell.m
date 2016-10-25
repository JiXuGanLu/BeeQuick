//
//  YBZYCheckOutPromotionCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutPromotionCell.h"

@interface YBZYCheckOutPromotionCell ()

@property (weak, nonatomic) IBOutlet UILabel *promotionNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *promotionAvailableLabel;

@end

@implementation YBZYCheckOutPromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setPromotionStyle:(NSString *)promotionStyle {
    _promotionStyle = promotionStyle;
    
    self.promotionNameLabel.text = promotionStyle;
    self.promotionAvailableLabel.text = [NSString stringWithFormat:@"暂无可用%@", promotionStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
