//
//  YBZYShopCartTipCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartTipCell.h"

@interface YBZYShopCartTipCell ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation YBZYShopCartTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
