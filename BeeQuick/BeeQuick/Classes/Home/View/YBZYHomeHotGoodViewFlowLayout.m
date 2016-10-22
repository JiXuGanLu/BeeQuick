//
//  YBZYHomeHotGoodViewFlowLayout.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeHotGoodViewFlowLayout.h"

@implementation YBZYHomeHotGoodViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat itemW = (YBZYScreenWidth - 1) / 2;
    CGFloat itemH = 260;
    self.itemSize = CGSizeMake(itemW, itemH);
    self.minimumLineSpacing = 1;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 16, 0);
}

@end
