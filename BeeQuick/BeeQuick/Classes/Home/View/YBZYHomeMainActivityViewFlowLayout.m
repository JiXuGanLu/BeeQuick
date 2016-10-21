//
//  YBZYHomeMainActivityViewFlowLayout.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeMainActivityViewFlowLayout.h"

@implementation YBZYHomeMainActivityViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat itemW = YBZYScreenWidth / 3.5;
    CGFloat itemH = self.collectionView.height;
    self.itemSize = CGSizeMake(itemW, itemH);
    self.minimumLineSpacing = 0.5;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
