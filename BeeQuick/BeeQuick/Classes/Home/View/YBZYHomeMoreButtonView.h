//
//  YBZYHomeMoreButtonView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZYHomeMoreButtonView;

@protocol YBZYHomeMoreButtonViewDelegate <NSObject>

- (void)didClickMoreButtonView:(YBZYHomeMoreButtonView *)moreButtonView;

@end

@interface YBZYHomeMoreButtonView : UIView

@property (nonatomic, weak) id<YBZYHomeMoreButtonViewDelegate> delegate;

@end
