//
//  YBZYHomeHeadLineViewCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeHeadLineViewCell.h"

@interface YBZYHomeHeadLineViewCell ()

@property (nonatomic,weak) UILabel *contentLabel;

@property (nonatomic,weak) UILabel *titleLabel;

@end

@implementation YBZYHomeHeadLineViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = YBZYCommonSmallFont;
    titleLabel.textColor = [UIColor redColor];
    titleLabel.layer.cornerRadius = 5;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.borderColor = [[UIColor redColor] CGColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(8);
        make.width.offset(30);
        make.height.offset(18);
        make.centerY.equalTo(self);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = YBZYCommonMidFont;
    contentLabel.textColor = YBZYCommonLightTextColor;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(8);
        make.centerY.equalTo(self);
    }];
}

- (void)setHeadLineModel:(YBZYHomeHeadLineModel *)headLineModel {
    _headLineModel = headLineModel;
    
    self.titleLabel.text = headLineModel.title;
    self.contentLabel.text = headLineModel.content;
}

@end
