//
//  YBZYHomeTableFooterView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeTableFooterView.h"
#import "YBZYHomeHotTitleView.h"
#import "YBZYHomeHotGoodView.h"
#import "YBZYHomeMoreButtonView.h"

@interface YBZYHomeTableFooterView () <YBZYHomeMoreButtonViewDelegate>

@property (nonatomic, weak) YBZYHomeHotGoodView *hotGoodView;

@property (nonatomic, weak) YBZYHomeMoreButtonView *moreButtonView;

@end

@implementation YBZYHomeTableFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self loadHotTitleView];
    [self loadHotGoodView];
    [self loadMoreButtonView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hotGoodView.superViewController = self.superViewController;
    });
}

- (void)loadHotTitleView {
    YBZYHomeHotTitleView *hotTitleView = [[YBZYHomeHotTitleView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, 30)];
    [self addSubview:hotTitleView];
}

- (void)loadHotGoodView {
    YBZYHomeHotGoodView *hotGoodView = [[YBZYHomeHotGoodView alloc] initWithFrame:CGRectMake(0, 30, YBZYScreenWidth, 1)];
    [self addSubview:hotGoodView];
    self.hotGoodView = hotGoodView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHotGoodViewHeight:) name:YBZYHomeTableFooterViewUpdateNotification object:nil];
}

- (void)updateHotGoodViewHeight:(NSNotification *)notification {
    CGFloat height = [notification.userInfo[@"height"] floatValue];
    self.hotGoodView.height = height;
    [self layoutIfNeeded];
}

- (void)loadMoreButtonView {
    YBZYHomeMoreButtonView *moreButtonView = [[YBZYHomeMoreButtonView alloc] init];
    [self addSubview:moreButtonView];
    moreButtonView.delegate = self;
    
    [moreButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotGoodView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(44);
    }];
}

- (void)didClickMoreButtonView:(YBZYHomeMoreButtonView *)moreButtonView {
    [self.superViewController.navigationController.tabBarController setSelectedIndex:1];
}

- (CGFloat)headerHeight {
    return 30;
}

- (CGFloat)footerHeight {
    return 44;
}

@end
