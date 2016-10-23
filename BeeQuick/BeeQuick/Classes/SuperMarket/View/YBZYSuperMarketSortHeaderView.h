//
//  YBZYSuperMarketSortHeaderView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/23.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZYSuperMarketSortHeaderView : UICollectionReusableView

@property (nonatomic, copy) NSString *sortStyle;

@property (nonatomic, copy) void(^coverViewBlock)();

@property (nonatomic, assign) BOOL isScrollToTop;

@property (nonatomic, copy) NSString *selectedCidName;

@property (nonatomic, copy) void(^changeSortBlock)(NSString *sortStyle);

@end
