//
//  YBZYAddressSelectCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressSelectCell.h"

@interface YBZYAddressSelectCell ()

@property (nonatomic, weak) UIView *selectedTag;

@property (nonatomic, weak) UILabel *receiverLabel;

@property (nonatomic, weak) UILabel *addressLabel;

@end

@implementation YBZYAddressSelectCell

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
    
    UIView *selectedTag = [[UIView alloc] init];
    selectedTag.backgroundColor = YBZYCommonYellowColor;
    [self.contentView addSubview:selectedTag];
    selectedTag.hidden = true;
    self.selectedTag = selectedTag;
    
    UILabel *receiverLabel = [UILabel ybzy_labelWithText:@"XXX 100861001010000" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    [self.contentView addSubview:receiverLabel];
    self.receiverLabel = receiverLabel;
    
    UILabel *addressLabel = [UILabel ybzy_labelWithText:@"怡红院宜春院四美塘丽春院等等" andTextColor:YBZYCommonMidTextColor andFontSize:14];
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    UIView *gapLine = [[UIView alloc] init];
    gapLine.backgroundColor = YBZYDarkBackgroundColor;
    [self.contentView addSubview:gapLine];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"v2_address_edit_normal"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"v2_address_edit_highlighted"] forState:UIControlStateHighlighted];
    [editButton addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editButton];
    
    [selectedTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(5);
        make.bottom.offset(-5);
        make.width.offset(5);
    }];
    
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(80);
    }];
    
    [gapLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.bottom.offset(-16);
        make.right.equalTo(editButton.mas_left);
        make.width.offset(1);
    }];
    
    [receiverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.offset(16);
        make.right.equalTo(gapLine.mas_left);
    }];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receiverLabel.mas_bottom).offset(10);
        make.left.offset(16);
        make.right.equalTo(gapLine.mas_left);
    }];
}

- (void)setAddressModel:(YBZYAddressModel *)addressModel {
    _addressModel = addressModel;
    
    [self.receiverLabel setText:addressModel.receiverString];
    [self.addressLabel setText:addressModel.addressString];
}

- (void)editAddress:(YBZYAddressModel *)addressModel {
    if ([self.delegate respondsToSelector:@selector(addressSelectCell:didClickEditButtonToEditAddress:)]) {
        [self.delegate addressSelectCell:self didClickEditButtonToEditAddress:self.addressModel];
    }
}

- (void)setIsCurrentAddress:(BOOL)isCurrentAddress {
    _isCurrentAddress = isCurrentAddress;
    
    if (isCurrentAddress) {
        self.selectedTag.hidden = false;
    } else {
        self.selectedTag.hidden = true;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
