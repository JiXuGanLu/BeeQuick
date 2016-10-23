//
//  YBZYSuperMarketSortHeaderView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/23.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSuperMarketSortHeaderView.h"

@interface YBZYSuperMarketSortHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *normalSortButton;

@property (weak, nonatomic) IBOutlet UIButton *priceSortButton;

@property (weak, nonatomic) IBOutlet UIButton *saleSortButton;

@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UIButton *coverViewButton;

@end

@implementation YBZYSuperMarketSortHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self.normalSortButton setSelected:true];
    self.sortStyle = @"综合排序";
}

- (void)setIsScrollToTop:(BOOL)isScrollToTop {
    _isScrollToTop = isScrollToTop;
    
    if (isScrollToTop) {
        self.coverView.alpha = 1;
    } else {
        self.coverView.alpha = 0;
    }
}

- (void)setSelectedCidName:(NSString *)selectedCidName {
    _selectedCidName = selectedCidName;
    
    NSString *sortMessage = [self.sortStyle stringByAppendingString:[NSString stringWithFormat:@"·%@", selectedCidName]];
    [self.coverViewButton setTitle:sortMessage forState:UIControlStateNormal];
}

- (IBAction)normalSortButtonClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    [sender setSelected:true];
    [self.priceSortButton setSelected:false];
    [self.priceSortButton setHighlighted:false];
    [self.saleSortButton setSelected:false];
    self.sortStyle = @"综合排序";
}

- (IBAction)priceSortButtonClick:(UIButton *)sender {
    if (sender.isSelected) {
        if ([self.sortStyle isEqualToString:@"价格最高"]) {
            [sender setImage:[UIImage imageNamed:@"control-up-red"] forState:UIControlStateSelected];
            self.sortStyle = @"价格最低";
        } else {
            [sender setImage:[UIImage imageNamed:@"control-down-red"] forState:UIControlStateSelected];
            self.sortStyle = @"价格最高";
        }
    } else {
        [sender setSelected:true];
        [self.normalSortButton setSelected:false];
        [self.saleSortButton setSelected:false];
        [sender setImage:[UIImage imageNamed:@"control-up-red"] forState:UIControlStateSelected];
        self.sortStyle = @"价格最低";
    }
}

- (IBAction)saleSortButtonClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    [sender setSelected:true];
    [self.priceSortButton setSelected:false];
    [self.priceSortButton setHighlighted:false];
    [self.normalSortButton setSelected:false];
    self.sortStyle = @"按销量";
}


- (IBAction)coverViewButtonClick:(UIButton *)sender {
    if (self.changeSortBlock) {
        self.changeSortBlock();
    }
}

@end
