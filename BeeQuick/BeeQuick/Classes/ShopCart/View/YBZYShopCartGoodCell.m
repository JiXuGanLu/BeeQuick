//
//  YBZYShopCartGoodCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/24.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYShopCartGoodCell.h"

@interface YBZYShopCartGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UILabel *specialTag;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) YBZYGoodModel *goodModel;

@end

@implementation YBZYShopCartGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.specialTag.layer setBorderColor:[UIColor redColor].CGColor];
    [self.specialTag.layer setBorderWidth:1];
    [self.specialTag.layer setCornerRadius:4];
    [self.specialTag.layer setMasksToBounds:true];
}

- (void)setGood:(NSDictionary *)good {
    _good = good;
    self.goodModel = good[@"goodModel"];
    
    self.selectButton.selected = [good[@"selected"] integerValue];
    self.countLabel.text = [good[@"count"] description];
    self.goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",@(self.goodModel.price).description];
    self.goodNameLabel.text = self.goodModel.name;
    [self.goodImage yy_setImageWithURL:[NSURL URLWithString:self.goodModel.img] placeholder:[UIImage imageNamed:@"v2_placeholder_square"]];
}

- (IBAction)selectButtonClick:(UIButton *)sender {
    if (self.selectButtonBlock) {
        self.selectButtonBlock(self.selectButton.isSelected, self.goodModel);
    }
}

- (IBAction)increaseButtonClick:(id)sender {
    if (self.editButtonBlock) {
        self.editButtonBlock(YBZYShopCartEditTypeIncrease, self.goodModel);
    }
}

- (IBAction)reduceButtonClick:(id)sender {
    if ([self.countLabel.text isEqualToString:@"1"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"要删除该商品吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
            if (self.editButtonBlock) {
                self.editButtonBlock(YBZYShopCartEditTypeReduce, self.goodModel);
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self.superViewController presentViewController:alertController animated:YES completion:nil];
    } else {
        if (self.editButtonBlock) {
            self.editButtonBlock(YBZYShopCartEditTypeReduce, self.goodModel);
        }
    }
}

- (IBAction)detailButtonClick:(UIButton *)sender {
    if (self.detailButtonBlock) {
        self.detailButtonBlock(self.goodModel);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
