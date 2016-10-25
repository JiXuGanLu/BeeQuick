//
//  YBZYCheckOutGoodListCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutGoodListCell.h"

@interface YBZYCheckOutGoodListCell ()

@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;

@property (nonatomic, strong) YBZYGoodModel *goodModel;

@end

@implementation YBZYCheckOutGoodListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setGoodInfo:(NSDictionary *)goodInfo {
    _goodInfo = goodInfo;
    
    self.goodModel = goodInfo[@"goodModel"];
    
    self.goodCountLabel.text = [goodInfo[@"count"] description];
    self.goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",@(self.goodModel.price).description];
    self.goodNameLabel.text = self.goodModel.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
