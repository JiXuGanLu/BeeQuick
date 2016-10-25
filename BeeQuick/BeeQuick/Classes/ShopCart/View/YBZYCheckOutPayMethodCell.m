//
//  YBZYCheckOutPayMethodCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutPayMethodCell.h"

@interface YBZYCheckOutPayMethodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UIImageView *selectedTag;

@end

@implementation YBZYCheckOutPayMethodCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setPayMethod:(YBZYCheckOutPayMethod)payMethod {
    _payMethod = payMethod;
    
    if (payMethod == YBZYCheckOutPayMethodALiPay) {
        self.payIcon.image = [UIImage imageNamed:@"v2_zfb"];
        self.payName.text = @"支付宝支付";
    } else if (payMethod == YBZYCheckOutPayMethodWeChatPay) {
        self.payIcon.image = [UIImage imageNamed:@"v2_weixin"];
        self.payName.text = @"微信支付";
    } else if (payMethod == YBZYCheckOutPayMethodQQPay) {
        self.payIcon.image = [UIImage imageNamed:@"icon_qq"];
        self.payName.text = @"QQ钱包";
    } else {
        self.payIcon.image = [UIImage imageNamed:@"v2_dao"];
        self.payName.text = @"货到付款";
    }
}

- (void)setPayMethodSelected:(BOOL)payMethodSelected {
    _payMethodSelected = payMethodSelected;
    
    if (payMethodSelected) {
        self.selectedTag.image = [UIImage imageNamed:@"v2_selected"];
    } else {
        self.selectedTag.image = [UIImage imageNamed:@"v2_noselected"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
