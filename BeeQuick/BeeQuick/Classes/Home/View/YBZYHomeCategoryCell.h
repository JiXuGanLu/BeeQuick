//
//  YBZYHomeCategoryCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBZYHomeCategoryModel.h"
#import "YBZYHomeCategoryGoodView.h"

@class YBZYHomeCategoryCell;

@protocol YBZYHomeCategoryCellDelegate <NSObject>

- (void)didClickPictureInHomeCategoryCell:(YBZYHomeCategoryCell *)cell;

- (void)didClickMoreButtonInHomeCategoryCell:(YBZYHomeCategoryCell *)cell;

@end

@interface YBZYHomeCategoryCell : UITableViewCell

@property (nonatomic, weak) id<YBZYHomeCategoryCellDelegate> delegate;

@property (nonatomic, strong) YBZYHomeCategoryModel *categoryModel;

@property (nonatomic, strong) NSArray<YBZYHomeCategoryGoodView *> *goodViews;

@end
