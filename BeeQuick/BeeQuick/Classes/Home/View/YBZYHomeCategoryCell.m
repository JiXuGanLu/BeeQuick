//
//  YBZYHomeCategoryCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeCategoryCell.h"

@interface YBZYHomeCategoryCell ()

// 色块
@property (nonatomic,weak) UIView *colorView;
// 更多按钮
@property (nonatomic,weak) UIButton *moreButton;
// 标题
@property (nonatomic,weak) UILabel *title;
// 大图
@property (nonatomic,weak) UIImageView *pictureView;

@end

@implementation YBZYHomeCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupUI];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat border = 8;
    CGFloat margin = 5;
    CGFloat pictureViewW = [UIScreen mainScreen].bounds.size.width - border * 2;
    
    UIView *colorView = [[UIView alloc] init];
    [self.contentView addSubview:colorView];
    self.colorView = colorView;
    
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(border);
        make.width.offset(3);
        make.height.offset(15);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"加载中...";
    title.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:title];
    self.title = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(colorView);
        make.left.equalTo(colorView.mas_right).offset(margin);
    }];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setImage:[UIImage imageNamed:@"baidu_wallet_arrow_right"] forState:UIControlStateNormal];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -moreButton.imageView.bounds.size.width * 6, 0, moreButton.imageView.bounds.size.width * 6)];
    [moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, moreButton.titleLabel.bounds.size.width * 6, 0, -moreButton.titleLabel.bounds.size.width * 6)];
    
    moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [self.contentView addSubview:moreButton];
    self.moreButton = moreButton;
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(colorView);
        make.right.offset(-18);
        make.width.offset(pictureViewW / 2);
        make.height.offset(colorView.bounds.size.height + 20);
    }];
    
    UIImageView *pictureView = [[UIImageView alloc] init];
    pictureView.userInteractionEnabled = true;
    pictureView.image = [UIImage imageNamed:@"test"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureViewClick:)];
    [pictureView addGestureRecognizer:tap];
    [self.contentView addSubview:pictureView];
    self.pictureView = pictureView;
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(89);
        make.width.offset(pictureViewW);
        make.top.equalTo(colorView.mas_bottom).offset(border);
        make.left.offset(border);
    }];
    
    YBZYHomeCategoryGoodView *goodView1 = [[YBZYHomeCategoryGoodView alloc] init];
    YBZYHomeCategoryGoodView *goodView2 = [[YBZYHomeCategoryGoodView alloc] init];
    YBZYHomeCategoryGoodView *goodView3 = [[YBZYHomeCategoryGoodView alloc] init];
    [self.contentView addSubview:goodView1];
    [self.contentView addSubview:goodView2];
    [self.contentView addSubview:goodView3];
    self.goodViews = @[goodView1, goodView2, goodView3];
    [self.goodViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pictureView.mas_bottom).offset(border);
        make.bottom.offset(0);
    }];
    for ( int i = 0; i < 2; i++) {
        UIView *currentView = self.goodViews[i];
        UIView *nextView = self.goodViews[i + 1];
        if (!i) {
            [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
            }];
        }
        if (i == 1) {
            [nextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
            }];
        }
        [nextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(currentView);
            make.left.equalTo(currentView.mas_right).offset(0);
        }];
    }
}

#pragma mark - 图片点击
- (void)pictureViewClick:(UIImageView *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPictureInHomeCategoryCell:)]) {
        [self.delegate didClickPictureInHomeCategoryCell:self];
    }
}

#pragma mark - 更多按钮点击
- (void)moreButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMoreButtonInHomeCategoryCell:)]) {
        [self.delegate didClickMoreButtonInHomeCategoryCell:self];
    }
}

#pragma mark - 模型赋值
- (void)setCategoryModel:(YBZYHomeCategoryModel *)categoryModel {
    _categoryModel = categoryModel;
    NSString *colorStr = [NSString stringWithFormat:@"0x%@", categoryModel.category_detail.category_color];
    NSUInteger color = strtoul([colorStr UTF8String], 0, 0);
    self.title.text = categoryModel.category_detail.name;
    self.colorView.backgroundColor = [UIColor ybzy_colorWithHex:(uint32_t)color];
    self.title.textColor = [UIColor ybzy_colorWithHex:(uint32_t)color];
    [self.pictureView yy_setImageWithURL:[NSURL URLWithString:categoryModel.activity.img] placeholder:nil];
    for (int i = 0; i < categoryModel.category_detail.goods.count; i++) {
        YBZYHomeCategoryGoodView *goodView = self.goodViews[i];
        goodView.goodModel = categoryModel.category_detail.goods[i];
    }
}

@end
