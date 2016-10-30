
//
//  YBZYAddressLocateCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressLocateCell.h"

@interface YBZYAddressLocateCell ()

@property (nonatomic, weak) UILabel *noticeLabel;

@end

@implementation YBZYAddressLocateCell

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
    
    UIImageView *locateLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2_address_locate"]];
    [self.contentView addSubview:locateLogo];
    
    UILabel *noticeLabel = [UILabel ybzy_labelWithText:@"定位到当前位置" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    [self.contentView addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView).offset(25);
    }];
    
    [locateLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(noticeLabel.mas_left).offset(-5);
    }];
}

- (void)setLocateString:(NSString *)locateString {
    _locateString = locateString.copy;
    
    [self.noticeLabel setText:locateString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
