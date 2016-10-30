//
//  YBZYAddressEditGenderCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressEditGenderCell.h"

@interface YBZYAddressEditGenderCell ()

@property (nonatomic, weak) UIButton *maleButton;

@property (nonatomic, weak) UIButton *femaleButton;

@end

@implementation YBZYAddressEditGenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *noSelectImage = [UIImage imageNamed:@"v2_noselected"];
    UIImage *selectImage = [UIImage imageNamed:@"v2_selected"];
    
    UIButton *maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [maleButton setImage:noSelectImage forState:UIControlStateNormal];
    [maleButton setImage:selectImage forState:UIControlStateSelected];
    [maleButton.imageView setFrame:CGRectMake(0, 0, 16, 16)];
    [maleButton setTitle:@"  先生" forState:UIControlStateNormal];
    [maleButton.titleLabel setFont:YBZYCommonBigFont];
    [maleButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
    [self.contentView addSubview:maleButton];
    self.maleButton = maleButton;
    [maleButton addTarget:self action:@selector(maleButtonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [femaleButton setImage:noSelectImage forState:UIControlStateNormal];
    [femaleButton setImage:selectImage forState:UIControlStateSelected];
    [femaleButton.imageView setFrame:CGRectMake(0, 0, 16, 16)];
    [femaleButton setTitle:@"  女士" forState:UIControlStateNormal];
    [femaleButton.titleLabel setFont:YBZYCommonBigFont];
    [femaleButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
    [self.contentView addSubview:femaleButton];
    self.femaleButton = femaleButton;
    [femaleButton addTarget:self action:@selector(femaleButtonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(116);
        make.centerY.equalTo(self.contentView);
        make.width.offset(80);
    }];
    
    [femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maleButton.mas_right).offset(40);
        make.centerY.equalTo(self.contentView);
        make.width.offset(80);
    }];
}

- (void)setOriginalGender:(NSString *)originalGender {
    _originalGender = originalGender.copy;
    
    if ([originalGender isEqualToString:@"先生"]) {
        [self.maleButton setSelected:true];
        [self.femaleButton setSelected:false];
    }
    if ([originalGender isEqualToString:@"女士"]) {
        [self.femaleButton setSelected:true];
        [self.maleButton setSelected:false];
    }
}

- (void)maleButtonDidSelect:(UIButton *)sender {
    [self.maleButton setSelected:true];
    [self.femaleButton setSelected:false];
    
    if (self.genderBlock) {
        self.genderBlock(@"先生");
    }
}

- (void)femaleButtonDidSelect:(UIButton *)sender {
    [self.femaleButton setSelected:true];
    [self.maleButton setSelected:false];
    
    if (self.genderBlock) {
        self.genderBlock(@"女士");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
