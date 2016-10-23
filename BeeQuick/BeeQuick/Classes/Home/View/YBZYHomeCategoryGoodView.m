//
//  YBZYHomeCategoryGoodView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeCategoryGoodView.h"

static CGFloat margin = 3;

@interface YBZYHomeCategoryGoodView ()
// 商品名
@property (nonatomic,weak) UILabel *nameLabel;
// 精选图标
@property (nonatomic,weak) UILabel *qualityLabel;
// 折扣信息
@property (nonatomic,weak) UILabel *pm_descLabel;
// 规格
@property (nonatomic,weak) UILabel *specificsLabel;
// 原价
@property (nonatomic,weak) UILabel *market_priceLabel;
// 折扣价
@property (nonatomic,weak) UILabel *priceLabel;
// 加号按钮
@property (nonatomic,weak) UIButton *addGoodButton;

@end

@implementation YBZYHomeCategoryGoodView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = true;
    [self addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(margin);
        make.right.offset(-margin);
        make.height.offset(130);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodImageDidClick:)];
    [imageView addGestureRecognizer:tap];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"加载中...";
    nameLabel.font = YBZYCommonMidFont;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.right.equalTo(imageView);
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
    [self addSubview:qualityLabel];
    self.qualityLabel = qualityLabel;
    [qualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(margin);
        make.left.equalTo(nameLabel);
        make.width.offset(35);
        make.height.offset(16);
    }];
    
    UILabel *pm_descLabel = [[UILabel alloc] init];
    pm_descLabel.text = @"买一赠一";
    pm_descLabel.backgroundColor = [UIColor redColor];
    pm_descLabel.font = YBZYCommonSmallFont;
    pm_descLabel.textColor = [UIColor whiteColor];
    pm_descLabel.layer.cornerRadius = 5;
    pm_descLabel.layer.masksToBounds = true;
    pm_descLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:pm_descLabel];
    self.pm_descLabel = pm_descLabel;
    [pm_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(margin);
        make.left.equalTo(qualityLabel.mas_right).offset(margin);
        make.height.equalTo(qualityLabel);
    }];
    
    UILabel *specificsLabel = [[UILabel alloc] init];
    specificsLabel.text = @"加载中...";
    specificsLabel.font = YBZYCommonSmallFont;
    specificsLabel.textColor = YBZYCommonLightTextColor;
    [self addSubview:specificsLabel];
    self.specificsLabel = specificsLabel;
    [specificsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pm_descLabel.mas_bottom).offset(margin);
        make.left.equalTo(nameLabel);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"¥9.9";
    priceLabel.font = [UIFont systemFontOfSize:12];
    priceLabel.textColor = [UIColor redColor];
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(specificsLabel.mas_bottom).offset(0);
        make.left.equalTo(nameLabel);
    }];
    
    UILabel *market_priceLabel = [[UILabel alloc] init];
    market_priceLabel.text = @"¥9.9";
    market_priceLabel.font = [UIFont systemFontOfSize:11];
    market_priceLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:market_priceLabel];
    self.market_priceLabel = market_priceLabel;
    [market_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(priceLabel);
        make.left.equalTo(priceLabel.mas_right).offset(margin);
    }];
    
    UIButton *addGoodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addGoodButton setImage:[UIImage imageNamed:@"v2_increase"] forState:UIControlStateNormal];
    [addGoodButton setImage:[UIImage imageNamed:@"v2_increased"] forState:UIControlStateSelected];
    [addGoodButton sizeToFit];
    [addGoodButton addTarget:self action:@selector(addGoodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addGoodButton];
    self.addGoodButton = addGoodButton;
    [addGoodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(34);
        make.right.bottom.offset(-margin);
    }];
}

#pragma mark - 加号按钮点击
- (void)addGoodButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddButtonInHomeCategoryGoodView:)]) {
        [self.delegate didClickAddButtonInHomeCategoryGoodView:self];
    }
}

#pragma mark - 图片点击
- (void)goodImageDidClick:(UIImageView *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickGoodImageInHomeCategoryGoodView:)]) {
        [self.delegate didClickGoodImageInHomeCategoryGoodView:self];
    }
}

#pragma mark - set模型

-(void)setGoodModel:(YBZYGoodModel *)goodModel {
    _goodModel = goodModel;
    
    NSUInteger length = goodModel.pm_desc.length;
    CGFloat labelW = self.pm_descLabel.font.lineHeight * (CGFloat)length;
    if (![goodModel.tag_ids isEqualToString:@"5"]) {
        self.qualityLabel.hidden = true;
        [self.pm_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(margin);
            make.height.offset(16);
            make.width.offset(labelW);
        }];
    } else {
        self.qualityLabel.hidden = false;
        [self.pm_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.qualityLabel.mas_right).offset(margin);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(margin);
            make.height.offset(16);
            make.width.offset(labelW);
        }];
    }
    
    self.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:goodModel.id userId:YBZYUserId].lastObject[@"count"] integerValue];
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:goodModel.img] placeholder:[UIImage imageNamed:@"v2_placeholder_square"]];
    self.nameLabel.text = goodModel.name;
    self.pm_descLabel.text = goodModel.pm_desc;
    self.specificsLabel.text = goodModel.specifics;
    self.priceLabel.text = goodModel.priceString;
    self.market_priceLabel.attributedText = goodModel.market_priceAttr;
}

- (void)setGoodCount:(NSInteger)goodCount {
    if (goodCount < 0) {
        return;
    }
    _goodCount = goodCount;
    if (goodCount > 0 ) {
        self.addGoodButton.selected = true;
    }
    else {
        self.addGoodButton.selected = false;
    }
}

@end
