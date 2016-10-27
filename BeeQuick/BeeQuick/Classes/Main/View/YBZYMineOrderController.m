//
//  YBZYMineOrderController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/27.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineOrderController.h"
#import "YBZYMineOrderAllController.h"
#import "YBZYMineOrderNotPayController.h"
#import "YBZYMineOrderNotConfirmController.h"
#import "YBZYMineOrderNotCommentController.h"
#import "YBZYMineOrderAfterSaleController.h"

@interface YBZYMineOrderController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<UIButton *> *orderButtons;

@property (nonatomic, weak) UIScrollView *orderDetailView;

@property (nonatomic, weak) UIView *orderCategoryLine;

@property (nonatomic, weak) UIView *orderCategoryView;

@end

@implementation YBZYMineOrderController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *initialButton = self.orderButtons[self.selectedCategory];
    initialButton.selected = true;
    
    [self.orderCategoryLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(44);
        make.height.offset(2);
        make.bottom.equalTo(self.orderCategoryView);
        make.centerX.equalTo(initialButton);
    }];
    
    [SVProgressHUD showWithStatus:@"查询中"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.orderDetailView setContentOffset:CGPointMake(self.selectedCategory * self.orderDetailView.bounds.size.width, 0) animated:false];
    [SVProgressHUD dismissWithDelay:0.5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationController.navigationBar.translucent = false;
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *orderCategoryView = [[UIView alloc] init];
    orderCategoryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderCategoryView];
    self.orderCategoryView = orderCategoryView;
    
    UIButton *allOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *notPayOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *notConfirmOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *notCommentOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *afterSaleOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allOrderButton setTitle:@"全部订单" forState:UIControlStateNormal];
    [notPayOrderButton setTitle:@"待付款" forState:UIControlStateNormal];
    [notConfirmOrderButton setTitle:@"待收货" forState:UIControlStateNormal];
    [notCommentOrderButton setTitle:@"待评价" forState:UIControlStateNormal];
    [afterSaleOrderButton setTitle:@"退款/售后" forState:UIControlStateNormal];
    
    self.orderButtons = @[allOrderButton, notPayOrderButton, notConfirmOrderButton, notCommentOrderButton, afterSaleOrderButton];
    for ( int i = 0; i < self.orderButtons.count; i++) {
        UIButton *button = self.orderButtons[i];
        button.titleLabel.font = YBZYCommonMidFont;
        [button setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(orderCategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [orderCategoryView addSubview:button];
    }
    
    UIView *orderCategoryLine = [[UIView alloc] init];
    orderCategoryLine.backgroundColor = [UIColor redColor];
    [orderCategoryView addSubview:orderCategoryLine];
    self.orderCategoryLine = orderCategoryLine;
    
    UIScrollView *orderDetailView = [[UIScrollView alloc] init];
    orderDetailView.backgroundColor = YBZYCommonBackgroundColor;
    orderDetailView.pagingEnabled = true;
    orderDetailView.bounces = false;
    orderDetailView.showsVerticalScrollIndicator = false;
    orderDetailView.showsHorizontalScrollIndicator = false;
    orderDetailView.delegate = self;
    [self.view addSubview:orderDetailView];
    self.orderDetailView = orderDetailView;
    
    YBZYMineOrderAllController *allController = [[YBZYMineOrderAllController alloc] init];
    YBZYMineOrderNotPayController *notPayController = [[YBZYMineOrderNotPayController alloc] init];
    YBZYMineOrderNotConfirmController *notConfirmController = [[YBZYMineOrderNotConfirmController alloc] init];
    YBZYMineOrderNotCommentController *notCommentController = [[YBZYMineOrderNotCommentController alloc] init];
    YBZYMineOrderAfterSaleController *afterSaleController = [[YBZYMineOrderAfterSaleController alloc] init];
    
    [orderDetailView addSubview:allController.view];
    [orderDetailView addSubview:notPayController.view];
    [orderDetailView addSubview:notConfirmController.view];
    [orderDetailView addSubview:notCommentController.view];
    [orderDetailView addSubview:afterSaleController.view];
    
    [self addChildViewController:allController];
    [self addChildViewController:notPayController];
    [self addChildViewController:notConfirmController];
    [self addChildViewController:notCommentController];
    [self addChildViewController:afterSaleController];
    
    [allController didMoveToParentViewController:self];
    [notPayController didMoveToParentViewController:self];
    [notConfirmController didMoveToParentViewController:self];
    [notCommentController didMoveToParentViewController:self];
    [afterSaleController didMoveToParentViewController:self];
    
    [orderCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(44);
    }];
    
    [self.orderButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
    }];
    for ( int i = 0; i < self.orderButtons.count - 1; i++) {
        UIButton *button = self.orderButtons[i];
        UIButton *nextButton = self.orderButtons[i + 1];
        if (i == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
            }];
        }
        if (i == self.orderButtons.count - 2) {
            [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
            }];
        }
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(button);
            make.left.equalTo(button.mas_right);
        }];
    }
    
    [orderCategoryLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(44);
        make.height.offset(2);
        make.bottom.offset(0);
        make.centerX.equalTo(allOrderButton);
    }];
    
    [orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.offset(0);
        make.top.equalTo(orderCategoryView.mas_bottom);
    }];
    
    [allController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.equalTo(orderDetailView);
        make.height.equalTo(orderDetailView);
    }];
    
    [notPayController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(allController.view.mas_right);
        make.width.equalTo(orderDetailView);
        make.height.equalTo(orderDetailView);
    }];
    
    [notConfirmController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(notPayController.view.mas_right);
        make.width.equalTo(orderDetailView);
        make.height.equalTo(orderDetailView);
    }];
    
    [notCommentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(notConfirmController.view.mas_right);
        make.width.equalTo(orderDetailView);
        make.height.equalTo(orderDetailView);
    }];
    
    [afterSaleController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.left.equalTo(notCommentController.view.mas_right);
        make.width.equalTo(orderDetailView);
        make.height.equalTo(orderDetailView);
    }];
}

- (void)orderCategoryButtonClick:(UIButton *)sender {
    sender.selected = true;
    
    for (UIButton *button in self.orderButtons) {
        if (button.tag != sender.tag) {
            button.selected = false;
        }
    }
    
    [self.orderDetailView setContentOffset:CGPointMake(sender.tag * self.orderDetailView.bounds.size.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIButton *button = [self.orderButtons firstObject];
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat minCenterXOffset = -(self.orderDetailView.bounds.size.width / 2 - button.bounds.size.width / 2);
    CGFloat centerXOffset = minCenterXOffset + button.bounds.size.width / self.orderDetailView.bounds.size.width * offsetX;
    
    [self.orderCategoryLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(44);
        make.height.offset(2);
        make.bottom.equalTo(self.orderCategoryView);
        make.centerX.offset(centerXOffset);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger buttonIndex = offsetX / self.orderDetailView.bounds.size.width;
    for (UIButton *button in self.orderButtons) {
        if (button.tag != buttonIndex) {
            button.selected = false;
        } else {
            button.selected = true;
        }
    }
}

@end
