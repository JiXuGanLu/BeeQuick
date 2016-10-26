//
//  YBZYMineHeaderView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/26.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineHeaderView.h"

@interface YBZYMineHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UIView *collectionBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *collectionGoodButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionStoreButton;

@end

@implementation YBZYMineHeaderView

+ (instancetype)headerView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"YBZYMineHeaderView" owner:nil options:nil];
    return [nibView firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.collectionBackgroundView.backgroundColor = YBZYCommonYellowColor;
}

- (IBAction)aboutButtonClick:(UIButton *)sender {
    if (self.aboutBlock) {
        self.aboutBlock();
    }
}

- (IBAction)collectionGoodButtonClick:(UIButton *)sender {
    if (self.collectionGoodBlock) {
        self.collectionGoodBlock();
    }
}

- (IBAction)collectionStoreButtonClick:(UIButton *)sender {
    if (self.collectionStoreBlock) {
        self.collectionStoreBlock();
    }
}

@end
