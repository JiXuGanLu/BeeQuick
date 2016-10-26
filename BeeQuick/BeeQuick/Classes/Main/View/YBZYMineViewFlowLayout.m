//
//  YBZYMineViewFlowLayout.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/26.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineViewFlowLayout.h"

@implementation YBZYMineViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

@end
