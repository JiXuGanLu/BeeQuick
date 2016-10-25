//
//  YBZYShopCartDeliverTimeCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartDeliverTimeCell.h"

@interface YBZYShopCartDeliverTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *deliverOrPickUpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editArrow;
@property (weak, nonatomic) IBOutlet UILabel *deliverTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@end

@implementation YBZYShopCartDeliverTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectedDeliverTime = @"一小时送达（可预定）";
}

- (void)setSelectedDeliverTime:(NSString *)selectedDeliverTime {
    _selectedDeliverTime = selectedDeliverTime;
    
    if ([selectedDeliverTime isEqualToString:@"店铺当天营业时间内"]) {
        self.deliverOrPickUpLabel.text = @"提货时间";
        self.editArrow.hidden = true;
        self.userInteractionEnabled = false;
    } else {
        self.deliverOrPickUpLabel.text = @"收货时间";
        self.editArrow.hidden = false;
        self.userInteractionEnabled = true;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:selectedDeliverTime];
    NSRange preRange = [selectedDeliverTime rangeOfString:selectedDeliverTime];
    if ([selectedDeliverTime isEqualToString:@"一小时送达（可预定）"]) {
        preRange = [selectedDeliverTime rangeOfString:@"一小时送达"];
    }
    NSRange subRange = [selectedDeliverTime rangeOfString:@"（可预定）"];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:preRange];
    [attrString addAttribute:NSForegroundColorAttributeName value:YBZYCommonDarkTextColor range:subRange];
    [self.deliverTimeLabel setAttributedText:attrString];
}

- (void)setFreightTip:(NSString *)freightTip {
    _freightTip = freightTip;
    [self.freightLabel setText:freightTip];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
