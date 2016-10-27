//
//  YBZYMineViewIconCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/26.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineViewIconCell.h"

@interface YBZYMineViewIconCell ()

@property (nonatomic, weak) UIImageView *iconImageView;

@property (nonatomic, weak) UILabel *iconTitleLabel;

@end

@implementation YBZYMineViewIconCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *iconTitleLabel = [UILabel ybzy_labelWithText:@"噢噢噢噢" andTextColor:YBZYCommonDarkTextColor andFontSize:12];
    [self.contentView addSubview:iconTitleLabel];
    self.iconTitleLabel = iconTitleLabel;
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-15);
        make.height.offset(25);
        make.width.offset(30);
    }];
    
    [iconTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(16);
    }];
}

- (void)setIconImageName:(NSString *)iconImageName {
    _iconImageName = iconImageName;
    
    [self.iconImageView setImage:[UIImage imageNamed:iconImageName]];
}

- (void)setIconTitle:(NSString *)iconTitle {
    _iconTitle = iconTitle;
    
    [self.iconTitleLabel setText:iconTitle];
}

@end
