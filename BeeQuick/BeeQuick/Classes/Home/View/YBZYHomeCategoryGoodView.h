//
//  YBZYHomeCategoryGoodView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZYHomeCategoryGoodView;

@protocol YBZYHomeCategoryGoodViewDelegate <NSObject>

- (void)didClickAddButtonInHomeCategoryGoodView:(YBZYHomeCategoryGoodView *)homeCategoryGoodView;

- (void)didClickGoodImageInHomeCategoryGoodView:(YBZYHomeCategoryGoodView *)homeCategoryGoodView;

@end

@interface YBZYHomeCategoryGoodView : UIView

@property (nonatomic, weak) id<YBZYHomeCategoryGoodViewDelegate> delegate;

@property (nonatomic, strong) YBZYGoodModel *goodModel;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, assign) NSInteger goodCount;

@end
