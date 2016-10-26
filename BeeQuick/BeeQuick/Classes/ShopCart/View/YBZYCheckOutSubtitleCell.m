//
//  YBZYCheckOutSubtitleCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYCheckOutSubtitleCell.h"

@interface YBZYCheckOutSubtitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation YBZYCheckOutSubtitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    
    self.subtitleLabel.text = subtitle;
}

@end
