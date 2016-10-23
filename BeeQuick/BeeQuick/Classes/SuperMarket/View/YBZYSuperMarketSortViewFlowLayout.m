//
//  YBZYSuperMarketSortViewFlowLayout.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/23.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYSuperMarketSortViewFlowLayout.h"

@implementation YBZYSuperMarketSortViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat itemW = self.collectionView.width / 3;
    CGFloat itemH = 44;
    self.itemSize = CGSizeMake(itemW, itemH);
    self.headerReferenceSize = CGSizeMake(self.collectionView.width, 44);
    self.footerReferenceSize = CGSizeMake(self.collectionView.width, 0.5);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    // 莫名其妙设置这个方向会导致cell数据源方法不调用。。。。。见鬼了，只好注释掉，反正也没用处
    // self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
