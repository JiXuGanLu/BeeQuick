//
//  YBZYHomeIconViewFlowLayout.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeIconViewFlowLayout.h"

@implementation YBZYHomeIconViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat w = self.collectionView.bounds.size.width / 4;
    CGFloat h = self.collectionView.bounds.size.height / 2;
    self.itemSize = CGSizeMake(w, h);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
}

@end
