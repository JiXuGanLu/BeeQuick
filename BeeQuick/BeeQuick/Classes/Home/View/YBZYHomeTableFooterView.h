//
//  YBZYHomeTableFooterView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBZYHomeHotGoodView.h"
#import "YBZYHomeMoreButtonView.h"

@interface YBZYHomeTableFooterView : UIView

@property (nonatomic, weak) UIViewController<YBZYHomeHotGoodViewCellDelegate, YBZYHomeMoreButtonViewDelegate> *superViewController;

@property (nonatomic, assign, readonly) CGFloat headerHeight;

@property (nonatomic, assign, readonly) CGFloat footerHeight;

@end
