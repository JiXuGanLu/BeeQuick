//
//  YBZYHomeTableView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeTableView.h"
#import "YBZYHomeCategoryModel.h"

static CGFloat rowHeight = 340;
static NSString *categoryCellId = @"categoryCellId";

@interface YBZYHomeTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *homeCategoryModels;

@property (nonatomic, weak) YBZYHomeTableHeaderView *headerView;

@property (nonatomic, weak) YBZYHomeTableFooterView *footerView;

@end

@implementation YBZYHomeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = YBZYCommonBackgroundColor;
    self.rowHeight = rowHeight;
    self.showsVerticalScrollIndicator = false;
    [self registerClass:[YBZYHomeCategoryCell class] forCellReuseIdentifier:categoryCellId];
    
    [self loadTableHeaderView];
    [self loadTableFooterView];
    [self loadRefreshView];
    [self loadHomeCategoryData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.headerView.superViewController = self.superViewController;
        self.footerView.superViewController = self.superViewController;
    });
}

- (void)loadTableHeaderView {
    YBZYHomeTableHeaderView *headerView = [[YBZYHomeTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, 660)];
    self.tableHeaderView = headerView;
    self.headerView = headerView;
    [self.tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
     // make.top.offset(0); // 大坑留念， 这里设置top约束，会让tableHeaderView无法接收用户交互
        make.height.offset(660);
    }];
}

- (void)loadTableFooterView {
    YBZYHomeTableFooterView *footView = [[YBZYHomeTableFooterView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, 75)];
    self.tableFooterView = footView;
    self.footerView = footView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableFooterViewHeight:) name:YBZYHomeTableFooterViewUpdateNotification object:nil];
}

- (void)updateTableFooterViewHeight:(NSNotification *)notification {
    CGFloat height = [notification.userInfo[@"height"] floatValue] + self.footerView.headerHeight + self.footerView.footerHeight;
    self.footerView.height = height;
    self.tableFooterView = self.footerView;//需要重新赋值！！！！否则滑不上去！！！因为tableFooterView的可滑动范围是在赋值的时候确定的，无法后期更改
    [self layoutIfNeeded];
}

- (void)loadRefreshView {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHomeCategoryData)];
    header.lastUpdatedTimeLabel.hidden = true;
    NSArray *refreshImage = @[[UIImage imageNamed:@"pushlistview_down"], [UIImage imageNamed:@"pushlistview_up"]];
    [header setImages:refreshImage forState:MJRefreshStateIdle];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setImages:refreshImage forState:MJRefreshStatePulling];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setImages:refreshImage forState:MJRefreshStateRefreshing];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    self.mj_header = header;
}

#pragma mark - 刷新方法

- (void)loadHomeCategoryData {
    YBZYHTTPSessionManager *manager = [YBZYHTTPSessionManager sharedSessionManager];
    [manager requestMethod:YBZYHTTPMethodGet URLString:@"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickHomeSections.json" parameters:nil completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        self.homeCategoryModels = [NSArray yy_modelArrayWithClass:[YBZYHomeCategoryModel class] json:response];
        [self reloadData];
        [self.mj_header endRefreshing];
    }];
}

#pragma mark - tableView数据源和代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.homeCategoryModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBZYHomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellId forIndexPath:indexPath];
    cell.categoryModel = self.homeCategoryModels[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self.superViewController;
    for ( int i = 0; i < cell.goodViews.count; i++) {
        cell.goodViews[i].delegate = self.superViewController;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 4;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.scrollBlock) {
        self.scrollBlock(offsetY);
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
