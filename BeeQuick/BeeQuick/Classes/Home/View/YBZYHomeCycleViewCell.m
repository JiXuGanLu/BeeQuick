//
//  YBZYHomeCycleViewCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeCycleViewCell.h"

@interface YBZYHomeCycleViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation YBZYHomeCycleViewCell

- (instancetype)initWithFrame:(CGRect)frame {
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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"v2_placeholder_highlight"];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    
    [self.imageView yy_setImageWithURL:imageURL placeholder:[UIImage imageNamed:@"v2_placeholder_highlight"]];
}

@end
