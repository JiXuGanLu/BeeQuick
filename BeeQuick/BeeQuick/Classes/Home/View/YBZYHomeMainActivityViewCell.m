//
//  YBZYHomeMainActivityViewCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeMainActivityViewCell.h"

@interface YBZYHomeMainActivityViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation YBZYHomeMainActivityViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.bottom.offset(0);
    }];
}

- (void)setActivityModel:(YBZYHomeCategoryActivityModel *)activityModel {
    _activityModel = activityModel;
    
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:activityModel.img] placeholder:nil];
}

@end
