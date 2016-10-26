//
//  YBZYMineViewTopCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/26.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineViewTopCell.h"

@interface YBZYMineViewTopCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *subTitleLabel;

@property (nonatomic, weak) UIImageView *accessoryImageView;

@end

@implementation YBZYMineViewTopCell

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
    
    UILabel *titleLabel = [UILabel ybzy_labelWithText:@"嗯嗯嗯嗯" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [UILabel ybzy_labelWithText:@"啊啊啊啊" andTextColor:YBZYCommonMidTextColor andFontSize:14];
    [self.contentView addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopcart_icon_arrow"]];
    [self.contentView addSubview:accessoryImageView];
    self.accessoryImageView = accessoryImageView;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-16);
        make.width.offset(8);
        make.height.offset(15);
    }];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-32);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    
    self.subTitleLabel.text = subTitle;
}

- (void)setIsAccessoryHidden:(BOOL)isAccessoryHidden {
    _isAccessoryHidden = isAccessoryHidden;
    
    if (isAccessoryHidden) {
        self.accessoryImageView.hidden = true;
    } else {
        self.accessoryImageView.hidden = false;
    }
}

@end
