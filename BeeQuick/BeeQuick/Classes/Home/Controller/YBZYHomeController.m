//
//  YBZYHomeController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeController.h"
#import "UINavigationBar+YBZY.h"
#import "YBZYHomeTableView.h"

@interface YBZYHomeController ()

@property (nonatomic, weak) YBZYHomeTableView *homeTableView;

@property (nonatomic, weak) UIButton *addressButton;

@property (nonatomic, strong) UIImage *itemBackgroundImage;

@property (nonatomic, assign) CGFloat scrollOffsetY;

@end

@implementation YBZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    [self setupTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar ybzy_reset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
}

#pragma mark - 导航栏设置
- (void)setupNavigationBar {
    [self.navigationController.navigationBar ybzy_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(scanButtonClick) icon:@"icon_white_scancode" highlighticon:nil backgroundImage:self.itemBackgroundImage];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(searchButtonClick) icon:@"icon_search_white" highlighticon:nil backgroundImage:self.itemBackgroundImage];
    
    UIButton *addressButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [addressButton setTitle:@"配送至: 新龙城居委会" forState:UIControlStateNormal];
    [addressButton.titleLabel setFont:YBZYCommonBigFont];
    [addressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addressButton setBackgroundImage:[[UIImage ybzy_imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(200, 30)] ybzy_cornerImageWithSize:CGSizeMake(200, 30) fillColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = addressButton;
    self.addressButton = addressButton;
}

- (void)scanButtonClick {
    
}

- (void)searchButtonClick {
    
}

- (void)addressButtonClick {
    
}

#pragma mark - tableview
- (void)setupTableView {
    YBZYHomeTableView *tableView = [[YBZYHomeTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.superViewController = self;
    [self.view addSubview:tableView];
    tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    __weak typeof(self) weakSelf = self;
    tableView.scrollBlock = ^(CGFloat offsetY) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.scrollOffsetY = offsetY;
        [strongSelf changeNavigationBarStyleWhenScroll:offsetY];
    };
}

- (void)changeNavigationBarStyleWhenScroll:(CGFloat)offsetY {
    CGFloat alpha = offsetY / 100.0;
    [self.navigationController.navigationBar ybzy_setBackgroundColor:[YBZYCommonYellowColor colorWithAlphaComponent:alpha >= 0 ? alpha : 0]];
    if (alpha >= 1) {
        self.addressButton.alpha = 1;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(scanButtonClick) icon:@"icon_black_scancode" highlighticon:nil backgroundImage:[UIImage ybzy_imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(searchButtonClick) icon:@"icon_search" highlighticon:nil backgroundImage:[UIImage ybzy_imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
        [self.addressButton setTitleColor:YBZYCommonDarkTextColor forState:UIControlStateNormal];
        [self.addressButton setBackgroundImage:nil forState:UIControlStateNormal];
    } else if (alpha >= 0) {
        self.addressButton.alpha = 1;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(scanButtonClick) icon:@"icon_white_scancode" highlighticon:nil backgroundImage:self.itemBackgroundImage];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem ybzy_barButtonItemWithTarget:self action:@selector(searchButtonClick) icon:@"icon_search_white" highlighticon:nil backgroundImage:self.itemBackgroundImage];
        [self.addressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addressButton setBackgroundImage:[[UIImage ybzy_imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(200, 30)] ybzy_cornerImageWithSize:CGSizeMake(200, 30) fillColor:[UIColor clearColor]] forState:UIControlStateNormal];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.addressButton.alpha = 0;
    }
}

- (UIImage *)itemBackgroundImage {
    return [[UIImage ybzy_imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(30, 30)] ybzy_cornerImageWithSize:CGSizeMake(30, 30) fillColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
