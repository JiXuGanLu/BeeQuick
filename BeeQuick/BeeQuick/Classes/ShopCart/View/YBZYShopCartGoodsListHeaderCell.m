//
//  YBZYShopCartGoodsListHeaderCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartGoodsListHeaderCell.h"

@interface YBZYShopCartGoodsListHeaderCell ()

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end

@implementation YBZYShopCartGoodsListHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tagView.backgroundColor = YBZYCommonYellowColor;
    self.tagView.layer.cornerRadius = 2;
    [self.tagView.layer setMasksToBounds:true];
}

- (void)setSourceName:(NSString *)sourceName {
    _sourceName = sourceName;
    self.sourceLabel.text = sourceName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
