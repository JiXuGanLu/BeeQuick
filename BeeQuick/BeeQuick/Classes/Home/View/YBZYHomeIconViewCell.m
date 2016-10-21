//
//  YBZYHomeIconViewCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeIconViewCell.h"

@interface YBZYHomeIconViewCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation YBZYHomeIconViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView* iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = YBZYCommonDarkTextColor;
    nameLabel.font = YBZYCommonSmallFont;
    nameLabel.text = @"";
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.offset(7);
        make.centerX.equalTo(self.contentView);
        make.width.offset(70);
        make.height.offset(50);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(iconView.mas_bottom).offset(3);
        make.centerX.equalTo(iconView);
    }];
}

- (void)setActivityModel:(YBZYHomeCategoryActivityModel *)activityModel {
    _activityModel = activityModel;
    
    [self.iconView yy_setImageWithURL:[NSURL URLWithString:activityModel.img] placeholder:[UIImage imageNamed:@"icon_icons_holder"]];
    self.nameLabel.text = activityModel.name;
}

@end
