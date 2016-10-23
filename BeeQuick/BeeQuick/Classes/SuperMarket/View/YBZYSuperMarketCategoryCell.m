//
//  YBZYSuperMarketCategoryCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSuperMarketCategoryCell.h"

@interface YBZYSuperMarketCategoryCell ()

@property (nonatomic, weak) UIView *selectedTagView;

@property (nonatomic, weak) UILabel *categoryNameLabel;

@property (nonatomic, weak) UIImageView *hotTagView;

@end

@implementation YBZYSuperMarketCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //要取消掉选择样式，才能让下面的setselected方法生效
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = YBZYCommonBackgroundColor;
    UIView *selectedTagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 30)];
    selectedTagView.backgroundColor = YBZYCommonYellowColor;
    selectedTagView.alpha = 0;
    [self.contentView addSubview:selectedTagView];
    selectedTagView.centerY = self.contentView.centerY;
    self.selectedTagView = selectedTagView;
    
    UILabel *categoryNameLabel = [[UILabel alloc] init];
    [categoryNameLabel setFont:YBZYCommonMidFont];
    [categoryNameLabel setTextColor:YBZYCommonMidTextColor];
    [categoryNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:categoryNameLabel];
    self.categoryNameLabel = categoryNameLabel;
}

- (void)setCategoryModel:(YBZYSuperMarketCategoryModel *)categoryModel {
    _categoryModel = categoryModel;
    self.categoryNameLabel.text = categoryModel.name;
    self.categoryNameLabel.frame = CGRectMake(0, 0, 60, 20);
    self.categoryNameLabel.center = self.contentView.center;
    
    if ([categoryModel.name isEqualToString:@"天天特价"]) {
        UIImageView *hotTagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invitebackhot"]];
        [self.contentView addSubview:hotTagView];
        self.hotTagView = hotTagView;
        [hotTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
        }];
    } else {
        [self.hotTagView removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectedTagView.alpha = 1;
        [self.categoryNameLabel setTextColor:YBZYCommonDarkTextColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        self.selectedTagView.alpha = 0;
        [self.categoryNameLabel setTextColor:YBZYCommonMidTextColor];
        self.contentView.backgroundColor = YBZYCommonBackgroundColor;
    }
}

@end
