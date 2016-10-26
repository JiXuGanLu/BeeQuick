//
//  YBZYPushView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/26.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZYPushView;

@protocol YBZYPushViewDelegate <NSObject>

- (void)pushAssignedViewcontroller:(UIViewController *)assignedViewcontroller;

@end

@interface YBZYPushView : UIView

@property (nonatomic, weak) id<YBZYPushViewDelegate> delegate;

@end
