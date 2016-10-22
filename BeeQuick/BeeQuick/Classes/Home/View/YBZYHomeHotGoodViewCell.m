//
//  YBZYHomeHotGoodViewCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeHotGoodViewCell.h"

static CGFloat margin = 5;

@interface YBZYHomeHotGoodViewCell ()

// 商品名
@property (nonatomic, weak) UILabel *nameLabel;
// 精选图标
@property (nonatomic, weak) UILabel *qualityLabel;
// 折扣信息
@property (nonatomic, weak) UILabel *pm_descLabel;
// 规格
@property (nonatomic, weak) UILabel *specificsLabel;
// 原价
@property (nonatomic, weak) UILabel *market_priceLabel;
// 折扣价
@property (nonatomic, weak) UILabel *priceLabel;
// 加号按钮
@property (nonatomic, weak) UIButton *addButton;
// 数量
@property (nonatomic, weak) UILabel *countLabel;
// 减号按钮
@property (nonatomic, weak) UIButton *reduceButton;

@end

@implementation YBZYHomeHotGoodViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat pictureH = self.bounds.size.height / 3 * 2 + margin;
    UIImageView *pictureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2_placeholder_square"]];
    pictureView.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictrueViewDidClick:)];
    [pictureView addGestureRecognizer:tapGes];
    [self.contentView addSubview:pictureView];
    self.pictureView = pictureView;
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(margin);
        make.right.offset(-margin);
        make.height.offset(pictureH);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = YBZYCommonMidFont;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pictureView.mas_bottom);
        make.right.equalTo(pictureView);
        make.left.offset(margin);
    }];
    
    UILabel *qualityLabel = [[UILabel alloc] init];
    qualityLabel.text = @"精选";
    qualityLabel.font = YBZYCommonSmallFont;
    qualityLabel.textColor = [UIColor redColor];
    qualityLabel.layer.borderWidth = 1;
    qualityLabel.layer.borderColor = [UIColor redColor].CGColor;
    qualityLabel.layer.cornerRadius = 5;
    qualityLabel.layer.masksToBounds = true;
    qualityLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:qualityLabel];
    self.qualityLabel = qualityLabel;
    [qualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(margin);
        make.left.equalTo(nameLabel);
        make.width.offset(35);
        make.height.offset(16);
    }];
    
    UILabel *pm_descLabel = [[UILabel alloc] init];
    pm_descLabel.backgroundColor = [UIColor redColor];
    pm_descLabel.font = YBZYCommonSmallFont;
    pm_descLabel.textColor = [UIColor whiteColor];
    pm_descLabel.layer.cornerRadius = 5;
    pm_descLabel.layer.masksToBounds = true;
    pm_descLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:pm_descLabel];
    self.pm_descLabel = pm_descLabel;
    [pm_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(margin);
        make.left.equalTo(qualityLabel.mas_right).offset(margin);
        make.height.equalTo(qualityLabel);
    }];
    
    UILabel *specificsLabel = [[UILabel alloc] init];
    specificsLabel.font = YBZYCommonSmallFont;
    specificsLabel.textColor = YBZYCommonLightTextColor;
    [self.contentView addSubview:specificsLabel];
    self.specificsLabel = specificsLabel;
    [specificsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pm_descLabel.mas_bottom).offset(margin);
        make.left.equalTo(nameLabel);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = YBZYCommonSmallFont;
    priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(specificsLabel.mas_bottom).offset(0);
        make.left.equalTo(nameLabel);
    }];
    
    UILabel *market_priceLabel = [[UILabel alloc] init];
    market_priceLabel.font = YBZYCommonSmallFont;
    market_priceLabel.textColor = YBZYCommonLightTextColor;
    [self.contentView addSubview:market_priceLabel];
    self.market_priceLabel = market_priceLabel;
    [market_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(priceLabel);
        make.left.equalTo(priceLabel.mas_right).offset(margin);
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"v2_increase"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"v2_increased"] forState:UIControlStateSelected];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(addButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addButton];
    self.addButton = addButton;
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(34);
        make.right.bottom.offset(-margin);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.hidden = true;
    countLabel.text = @"1";
    countLabel.font = YBZYCommonSmallFont;
    countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addButton);
        make.right.equalTo(addButton.mas_left).offset(margin);
        make.width.offset(26);
    }];
    
    UIButton *reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceButton.hidden = true;
    [reduceButton addTarget:self action:@selector(reduceButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [reduceButton setImage:[UIImage imageNamed:@"v2_reduced"] forState:UIControlStateNormal];
    [reduceButton sizeToFit];
    [self.contentView addSubview:reduceButton];
    self.reduceButton = reduceButton;
    [reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(addButton);
        make.right.equalTo(countLabel.mas_left).offset(margin);
    }];
}

#pragma mark - 图片点击
- (void)pictrueViewDidClick:(UIImageView *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPictureInHomeHotGoodViewCell:)]) {
        [self.delegate didClickPictureInHomeHotGoodViewCell:self];
    }
}

#pragma mark - 按钮点击事件
- (void)addButtonDidClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddButtonInHomeHotGoodViewCell:)]) {
        [self.delegate didClickAddButtonInHomeHotGoodViewCell:self];
    }
}

- (void)reduceButtonDidClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReduceButtonInHomeHotGoodViewCell:)]) {
        [self.delegate didClickReduceButtonInHomeHotGoodViewCell:self];
    }
}

#pragma mark - 商品数量计数 减号按钮是否隐藏
- (void)setGoodCount:(NSInteger)goodCount {
    if (goodCount < 0) {
        return;
    }
    
    _goodCount = goodCount;
    if (goodCount > 0) {
        self.addButton.selected = true;
        self.reduceButton.hidden = false;
        self.countLabel.hidden = false;
    } else {
        self.addButton.selected = false;
        self.reduceButton.hidden = true;
        self.countLabel.hidden = true;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zd", goodCount];
    [self.superview layoutIfNeeded];
}

#pragma mark - set模型

- (void)setGoodModel:(YBZYGoodModel *)goodModel {
    _goodModel = goodModel;
    
    self.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:goodModel.id userId:YBZYUserId].lastObject[@"count"] integerValue];
    self.countLabel.text = [NSString stringWithFormat:@"%zd", self.goodModel];
    [self.pictureView yy_setImageWithURL:[NSURL URLWithString:goodModel.img] placeholder:nil];
    self.nameLabel.text = goodModel.name;
    if (![goodModel.tag_ids isEqualToString:@"5"]) {
        self.qualityLabel.hidden = true;
        [self.pm_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(margin);
            make.height.equalTo(self.qualityLabel);
        }];
    }
    NSUInteger length = goodModel.pm_desc.length;
    CGFloat labelW = self.pm_descLabel.font.lineHeight * (CGFloat)length;
    [self.pm_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.qualityLabel.mas_right).offset(margin);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(margin);
        make.height.equalTo(self.qualityLabel);
        make.width.offset(labelW);
    }];
    self.pm_descLabel.text = goodModel.pm_desc;
    self.specificsLabel.text = goodModel.specifics;
    self.priceLabel.text = goodModel.priceString;
    self.market_priceLabel.attributedText = goodModel.market_priceAttr;
}

@end
