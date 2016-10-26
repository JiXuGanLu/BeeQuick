//
//  YBZYHomeTableHeaderView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeTableHeaderView.h"
#import "YBZYHomeCycleView.h"
#import "YBZYHomeIconView.h"
#import "YBZYHomeHeadLineView.h"
#import "YBZYHomeMainActivityView.h"
#import "YBZYHomeMinorActivityView.h"

@interface YBZYHomeTableHeaderView ()

@property (nonatomic, weak) YBZYHomeCycleView *cycleView;

@property (nonatomic, weak) YBZYHomeIconView *iconView;

@property (nonatomic, weak) YBZYHomeHeadLineView *headLineView;

@property (nonatomic, weak) YBZYHomeMainActivityView *mainActivityView;

@property (nonatomic, weak) YBZYHomeMinorActivityView *minorActivityView;

@end

@implementation YBZYHomeTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = YBZYCommonBackgroundColor;
    [self setupCycleView];
    [self setupIconView];
    [self setupHeadLineView];
    [self setupMainActivityView];
    [self setupMinorActivityView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cycleView.delegate = self.superViewController;
        self.iconView.delegate = self.superViewController;
        self.headLineView.delegate = self.superViewController;
        self.mainActivityView.delegate = self.superViewController;
        self.minorActivityView.delegate = self.superViewController;
    });
}

- (void)setupCycleView {
    YBZYHomeCycleView *cycleView = [[YBZYHomeCycleView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, 170)];
    [self addSubview:cycleView];
    self.cycleView = cycleView;
}

- (void)setupIconView {
    YBZYHomeIconView *iconView = [[YBZYHomeIconView alloc] initWithFrame:CGRectMake(0, 170, YBZYScreenWidth, 160)];
    [self addSubview:iconView];
    self.iconView = iconView;
}

- (void)setupHeadLineView {
    YBZYHomeHeadLineView *headLineView = [[YBZYHomeHeadLineView alloc] initWithFrame:CGRectMake(0, 330, YBZYScreenWidth, 30)];
    [self addSubview:headLineView];
    self.headLineView = headLineView;
}

- (void)setupMainActivityView {
    YBZYHomeMainActivityView *mainActivityView = [[YBZYHomeMainActivityView alloc] initWithFrame:CGRectMake(0, 368, YBZYScreenWidth, 140)];
    [self addSubview:mainActivityView];
    self.mainActivityView = mainActivityView;
}

- (void)setupMinorActivityView {
    YBZYHomeMinorActivityView *minorActivityView = [[YBZYHomeMinorActivityView alloc] initWithFrame:CGRectMake(0, 516, YBZYScreenWidth, 140)];
    [self addSubview:minorActivityView];
    self.minorActivityView = minorActivityView;
}

@end
