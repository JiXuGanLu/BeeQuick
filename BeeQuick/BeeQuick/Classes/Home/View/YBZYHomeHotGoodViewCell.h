//
//  YBZYHomeHotGoodViewCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZYHomeHotGoodViewCell;

@protocol YBZYHomeHotGoodViewCellDelegate <NSObject>

- (void)didClickAddButtonInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell;

- (void)didClickReduceButtonInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell;

- (void)didClickPictureInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell;

@end

@interface YBZYHomeHotGoodViewCell : UICollectionViewCell

@property (nonatomic, strong) YBZYGoodModel *goodModel;

@property (nonatomic, assign) NSInteger goodCount;

@property (nonatomic, weak) id<YBZYHomeHotGoodViewCellDelegate> delegate;

@property (nonatomic, weak) UIImageView *pictureView;

@end
