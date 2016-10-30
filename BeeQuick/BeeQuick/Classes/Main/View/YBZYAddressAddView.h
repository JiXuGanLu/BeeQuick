//
//  YBZYAddressAddView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZYAddressAddView;

@protocol YBZYAddressAddViewDelegate <NSObject>

- (void)addressAddViewDidClickAddButton:(YBZYAddressAddView *)addView;

@end

@interface YBZYAddressAddView : UIView

@property (nonatomic, weak) id<YBZYAddressAddViewDelegate> delegate;

@end
