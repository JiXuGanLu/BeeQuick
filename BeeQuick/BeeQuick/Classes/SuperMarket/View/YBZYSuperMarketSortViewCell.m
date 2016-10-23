//
//  YBZYSuperMarketSortViewCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/23.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSuperMarketSortViewCell.h"

@interface YBZYSuperMarketSortViewCell ()

@property (nonatomic, weak) UIView *normalBackgroundView;

@property (nonatomic, weak) UILabel *sortLabel;

@end

@implementation YBZYSuperMarketSortViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *normalBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 28)];
    normalBackgroundView.backgroundColor = YBZYCommonBackgroundColor;
    normalBackgroundView.layer.borderWidth = 1;
    normalBackgroundView.layer.borderColor = YBZYDarkBackgroundColor.CGColor;
    normalBackgroundView.layer.cornerRadius = 4;
    normalBackgroundView.layer.masksToBounds = true;
    [self.contentView addSubview:normalBackgroundView];
    self.normalBackgroundView = normalBackgroundView;
    normalBackgroundView.center = self.contentView.center;
    
    UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 72, 20)];
    [sortLabel setFont:YBZYCommonSmallFont];
    [sortLabel setTextColor:YBZYCommonMidTextColor];
    [sortLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:sortLabel];
    self.sortLabel = sortLabel;
    sortLabel.center = self.contentView.center;
}

- (void)setCidModel:(YBZYSuperMarketCidModel *)cidModel {
    _cidModel = cidModel;
    
    self.sortLabel.text = cidModel.name;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.normalBackgroundView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.1];
        self.normalBackgroundView.layer.borderColor = YBZYCommonYellowColor.CGColor;
        [self.sortLabel setTextColor:[UIColor orangeColor]];
    } else {
        self.normalBackgroundView.backgroundColor = YBZYCommonBackgroundColor;
        self.normalBackgroundView.layer.borderColor = YBZYDarkBackgroundColor.CGColor;
        [self.sortLabel setTextColor:YBZYCommonMidTextColor];
    }
}

@end
