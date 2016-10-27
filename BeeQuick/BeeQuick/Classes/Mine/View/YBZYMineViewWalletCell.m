//
//  YBZYMineViewWalletCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/26.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineViewWalletCell.h"

@interface YBZYMineViewWalletCell ()

@property (nonatomic, weak) UILabel *numberLabel;

@property (nonatomic, weak) UILabel *walletTypeLabel;

@end

@implementation YBZYMineViewWalletCell

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
    
    UILabel *numberLabel = [UILabel ybzy_labelWithText:@"¥9.98" andTextColor:YBZYCommonDarkTextColor andFontSize:12];
    [self.contentView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    UILabel *walletTypeLabel = [UILabel ybzy_labelWithText:@"余粮" andTextColor:YBZYCommonDarkTextColor andFontSize:12];
    [self.contentView addSubview:walletTypeLabel];
    self.walletTypeLabel = walletTypeLabel;
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-12);
    }];
    
    [walletTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(12);
    }];
}

- (void)setNumberString:(NSString *)numberString {
    _numberString = numberString;
    
    [self.numberLabel setText:numberString];
}

- (void)setWalletType:(NSString *)walletType {
    _walletType = walletType;
    
    [self.walletTypeLabel setText:walletType];
}

@end
