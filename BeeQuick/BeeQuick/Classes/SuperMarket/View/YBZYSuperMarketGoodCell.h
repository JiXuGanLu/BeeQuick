//
//  YBZYSuperMarketGoodCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZYSuperMarketGoodCell;

@protocol YBZYSuperMarketGoodCellDelegate <NSObject>

- (void)didClickAddButtonInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell;

- (void)didClickReduceButtonInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell;

- (void)didClickPictureInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell;

@end

@interface YBZYSuperMarketGoodCell : UITableViewCell

@property (nonatomic, strong) YBZYGoodModel *goodModel;

@property (nonatomic, assign) NSInteger goodCount;

@property (nonatomic, weak) id<YBZYSuperMarketGoodCellDelegate> delegate;

@property (nonatomic, weak) UIImageView *pictureView;

@end
