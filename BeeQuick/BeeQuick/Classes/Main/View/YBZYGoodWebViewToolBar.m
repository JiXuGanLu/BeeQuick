//
//  YBZYGoodWebViewToolBar.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/30.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYGoodWebViewToolBar.h"

@interface YBZYGoodWebViewToolBar ()

@property (nonatomic, weak) UIButton *collectButton;
@property (nonatomic, weak) UIButton *reduceButton;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, weak) UIButton *addButton;

@end

@implementation YBZYGoodWebViewToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = YBZYCommonBackgroundColor;
    
    UIView *gapLine = [[UIView alloc] init];
    gapLine.backgroundColor = YBZYDarkBackgroundColor;
    [self addSubview:gapLine];
    
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.backgroundColor = [UIColor clearColor];
    [collectButton setAttributedTitle:[NSAttributedString ybzy_imageTextWithImage:[UIImage imageNamed:@"non_collection"] imageWH:18.0 title:@"收藏" fontSize:10 titleColor:YBZYCommonDarkTextColor spacing:4] forState:UIControlStateNormal];
    [collectButton setAttributedTitle:[NSAttributedString ybzy_imageTextWithImage:[UIImage imageNamed:@"already_collect"] imageWH:18.0 title:@"已收藏" fontSize:10 titleColor:YBZYCommonDarkTextColor spacing:4] forState:UIControlStateSelected];
    collectButton.titleLabel.numberOfLines = 0;
    collectButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:collectButton];
    self.collectButton = collectButton;
    
    UILabel *noticeLabel = [UILabel ybzy_labelWithText:@"添加商品:" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    [noticeLabel sizeToFit];
    [self addSubview:noticeLabel];
    
    UIButton *reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reduceButton addTarget:self action:@selector(reduceButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    reduceButton.enabled = false;
    [reduceButton setImage:[UIImage imageNamed:@"v2_reduced"] forState:UIControlStateNormal];
    [reduceButton setImage:[UIImage imageNamed:@"v2_reduce"] forState:UIControlStateDisabled];
    [reduceButton sizeToFit];
    [self addSubview:reduceButton];
    self.reduceButton = reduceButton;
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"0";
    countLabel.font = YBZYCommonSmallFont;
    countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:countLabel];
    self.countLabel = countLabel;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"v2_increase"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"v2_increased"] forState:UIControlStateSelected];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(addButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
    self.addButton = addButton;
    
    [gapLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(1 / [UIScreen mainScreen].scale);
    }];
    
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.offset(60);
    }];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.equalTo(self);
        make.height.width.offset(30);
    }];
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addButton.mas_left);
        make.centerY.equalTo(self);
        make.width.offset(30);
    }];
    
    [reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(countLabel.mas_left);
        make.centerY.equalTo(self);
        make.height.width.offset(30);
    }];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(reduceButton.mas_left).offset(-8);
        make.centerY.equalTo(self);
    }];
}

- (void)setIsCollected:(BOOL)isCollected {
    _isCollected = isCollected;
    
    if (isCollected) {
        [self.collectButton setSelected:true];
    } else {
        [self.collectButton setSelected:false];
    }
}

- (void)setGoodCount:(NSInteger)goodCount {
    _goodCount = goodCount;
    
    [self.countLabel setText:[NSString stringWithFormat:@"%zd", goodCount]];
    if (goodCount) {
        self.reduceButton.enabled = true;
        self.addButton.selected = true;
    } else {
        self.reduceButton.enabled = false;
        self.addButton.selected = false;
    }
}

- (void)reduceButtonDidClick:(UIButton *)sender {
    if (self.reduceBlock) {
        self.reduceBlock();
    }
}

- (void)addButtonDidClick:(UIButton *)sender {
    if (self.addBlock) {
        self.addBlock();
    }
}

- (void)collectButtonClick:(UIButton *)sender {
    if (self.collectBlock) {
        self.collectBlock();
    }
}

@end
