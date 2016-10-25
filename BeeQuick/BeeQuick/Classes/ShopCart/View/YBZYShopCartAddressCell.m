//
//  YBZYShopCartAddressCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartAddressCell.h"

@interface YBZYShopCartAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *pickUpNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;

@end

@implementation YBZYShopCartAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.pickUpTagLabel.backgroundColor = YBZYCommonYellowColor;
    [self.pickUpTagLabel.layer setCornerRadius:4];
    [self.pickUpTagLabel.layer setMasksToBounds:true];
}

@end
