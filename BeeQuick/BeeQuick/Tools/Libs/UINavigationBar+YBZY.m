//
//  UINavigationBar+YBZY.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "UINavigationBar+YBZY.h"
#import <objc/runtime.h>

static char coverViewKey;

@implementation UINavigationBar (YBZY)

- (UIView *)coverView {
    return objc_getAssociatedObject(self, &coverViewKey);
}

- (void)setCoverView:(UIView *)coverView {
    objc_setAssociatedObject(self, &coverViewKey, coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ybzy_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.coverView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        self.coverView.userInteractionEnabled = NO;
        self.coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.coverView atIndex:0];
    }
    self.coverView.backgroundColor = backgroundColor;
}

- (void)ybzy_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
    [self.coverView removeFromSuperview];
    self.coverView = nil;
}

@end
