//
//  YBZYAddressPickUpCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/30.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressPickUpCell.h"

@interface YBZYAddressPickUpCell ()

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *workingTimeLabel;

@property (nonatomic, weak) UILabel *addressLabel;

@property (nonatomic, weak) UILabel *distanceLabel;

@property (nonatomic, weak) UIView *selectedTag;

@end

@implementation YBZYAddressPickUpCell

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
    UIView *selectedTag = [[UIView alloc] init];
    selectedTag.backgroundColor = YBZYCommonYellowColor;
    [self.contentView addSubview:selectedTag];
    selectedTag.hidden = true;
    self.selectedTag = selectedTag;
    
    UILabel *nameLabel = [UILabel ybzy_labelWithText:@"呵呵呵呵呵呵呵呵呵呵呵呵呵" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *workingTimeLabel = [UILabel ybzy_labelWithText:@"嗯嗯嗯嗯嗯嗯嗯嗯嗯嗯嗯嗯嗯" andTextColor:YBZYCommonLightTextColor andFontSize:12];
    [self.contentView addSubview:workingTimeLabel];
    self.workingTimeLabel = workingTimeLabel;
    
    UILabel *addressLabel = [UILabel ybzy_labelWithText:@"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊" andTextColor:YBZYCommonLightTextColor andFontSize:12];
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    UILabel *distanceLabel = [UILabel ybzy_labelWithText:@"0.99km" andTextColor:YBZYCommonLightTextColor andFontSize:12];
    [self.contentView addSubview:distanceLabel];
    self.distanceLabel = distanceLabel;
    
    UIView *gapLine = [[UIView alloc] init];
    gapLine.backgroundColor = YBZYDarkBackgroundColor;
    [self.contentView addSubview:gapLine];
    
    UIImageView *locateLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bqLocationIcon"]];
    [self.contentView addSubview:locateLogo];
    
    [selectedTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(5);
        make.bottom.offset(-5);
        make.width.offset(5);
    }];
    
    [locateLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(15);
        make.height.offset(20);
        make.right.offset(-40);
        make.centerY.equalTo(self.contentView).offset(-10);
    }];
    
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(locateLogo);
        make.centerY.equalTo(self.contentView).offset(10);
    }];
    
    [gapLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.bottom.offset(-16);
        make.right.offset(-95);
        make.width.offset(1);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(16);
        make.right.equalTo(gapLine.mas_left).offset(-16);
    }];
    
    [workingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(nameLabel.mas_bottom).offset(8);
        make.right.equalTo(gapLine.mas_left).offset(-16);
    }];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(workingTimeLabel.mas_bottom).offset(8);
        make.right.equalTo(gapLine.mas_left).offset(-16);
    }];
}

- (void)setPickUpModel:(YBZYPickUpModel *)pickUpModel {
    _pickUpModel = pickUpModel;
    
    [self.nameLabel setText:pickUpModel.dealer_alias];
    [self.workingTimeLabel setText:[NSString stringWithFormat:@"营业时间: %@", pickUpModel.workingTimeString]];
    [self.addressLabel setText:pickUpModel.address];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm", pickUpModel.distance]];
}

- (void)setIsCurrentPickUp:(BOOL)isCurrentPickUp {
    _isCurrentPickUp = isCurrentPickUp;
    
    if (isCurrentPickUp) {
        self.selectedTag.hidden = false;
    } else {
        self.selectedTag.hidden = true;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
