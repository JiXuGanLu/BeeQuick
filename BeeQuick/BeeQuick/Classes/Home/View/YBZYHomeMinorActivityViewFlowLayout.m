//
//  YBZYHomeMinorActivityViewFlowLayout.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeMinorActivityViewFlowLayout.h"

@implementation YBZYHomeMinorActivityViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat itemW = (self.collectionView.bounds.size.width - 0.5) / 2;
    CGFloat itemH = (self.collectionView.bounds.size.height - 0.5) / 2;
    self.itemSize = CGSizeMake(itemW, itemH);
    self.minimumLineSpacing = 0.5;
    self.minimumInteritemSpacing = 0.5;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

@end
