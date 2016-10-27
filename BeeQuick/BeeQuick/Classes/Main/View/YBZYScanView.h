//
//  YBZYScanView.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/27.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZYScanView;

@protocol YBZYScanViewDelegate <NSObject>

- (void)scanView:(YBZYScanView *)scanView scanSuccessWithCodeInfo:(NSString *)codeInfo;

@end

@interface YBZYScanView : UIView

@property (nonatomic, weak) id<YBZYScanViewDelegate> delegate;

- (void)startScan;

- (void)stopScan;

@end
