//
//  YBZYHomeTableView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeTableView.h"
#import "YBZYHomeCategoryCell.h"
#import "YBZYHomeCategoryModel.h"
#import "YBZYHomeTableHeaderView.h"

const CGFloat rowHeight = 340;
static NSString *categoryCellId = @"categoryCellId";
static NSString *addGoodAnimKey = @"addGoodAnimKey";

@interface YBZYHomeTableView () <UITableViewDelegate, UITableViewDataSource, YBZYHomeCategoryCellDelegate, YBZYHomeCategoryGoodViewDelegate, CAAnimationDelegate>

@property (nonatomic, strong) NSArray *homeCategoryModels;

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
}

- (void)loadTableHeaderView {
    YBZYHomeTableHeaderView *headerView = [[YBZYHomeTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, 660)];
    self.tableHeaderView = headerView;
    [self.tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(0); // 大坑留念， 这里设置top约束，会让tableHeaderView无法接收用户交互
        make.height.offset(660);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        headerView.superViewController = self.superViewController;
    });
}

- (void)loadTableFooterView {
    
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
    cell.delegate = self;
    for ( int i = 0; i < cell.goodViews.count; i++) {
        cell.goodViews[i].delegate = self;
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

#pragma mark - cell和goodView代理

- (void)didClickPictureInHomeCategoryCell:(YBZYHomeCategoryCell *)cell {
    YBZYActivityWebViewController *actWebVC = [[YBZYActivityWebViewController alloc] init];
    actWebVC.urlString = cell.categoryModel.activity.urlString;
    actWebVC.title = cell.categoryModel.activity.name;
    
    [self.superViewController.navigationController pushViewController:actWebVC animated:true];
}

- (void)didClickMoreButtonInHomeCategoryCell:(YBZYHomeCategoryCell *)cell {
    [self.superViewController.navigationController.tabBarController setSelectedIndex:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYPushSuperMarketNotification object:nil userInfo:@{YBZYCategoryKey :cell.categoryModel.category_detail.category_id}];
}

- (void)didClickGoodImageInHomeCategoryGoodView:(YBZYHomeCategoryGoodView *)homeCategoryGoodView {
    YBZYGoodWebViewController *goodWebVC = [[YBZYGoodWebViewController alloc] init];
    goodWebVC.goodModel = homeCategoryGoodView.goodModel;
    
    [self.superViewController.navigationController pushViewController:goodWebVC animated:true];
}

- (void)didClickAddButtonInHomeCategoryGoodView:(YBZYHomeCategoryGoodView *)homeCategoryGoodView {
    [[YBZYSQLiteManager sharedManager] addGood:homeCategoryGoodView.goodModel withId:homeCategoryGoodView.goodModel.id userId:YBZYUserId goodsType:homeCategoryGoodView.goodModel.goods_type];
    homeCategoryGoodView.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:homeCategoryGoodView.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddGoodNotification object:nil];
    
    CGPoint start = [homeCategoryGoodView convertPoint:homeCategoryGoodView.imageView.center toView:self.window];
    CGPoint end = [self.window convertPoint:CGPointMake(YBZYScreenWidth / 10 * 7, YBZYScreenHeight - 40) toView:self.window];
    CAKeyframeAnimation *anim = [[CAKeyframeAnimation alloc] init];
    anim.keyPath = @"position";
    anim.duration = .9;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    [path addQuadCurveToPoint:end controlPoint:CGPointMake(start.x + 40, start.y - 40)];
    anim.path = path.CGPath;
    anim.delegate = self;
    
    UIImageView *pictureView = [[UIImageView alloc] initWithImage:homeCategoryGoodView.imageView.image];
    pictureView.frame = homeCategoryGoodView.imageView.frame;
    CGAffineTransform tran = homeCategoryGoodView.imageView.transform;
    pictureView.transform = tran;
    [self.window addSubview:pictureView];
    [anim setValue:pictureView forKey:addGoodAnimKey];
    [pictureView.layer addAnimation:anim forKey:nil];
    tran = CGAffineTransformMakeScale(.1, .1);
    tran = CGAffineTransformRotate(tran, M_PI_4 + M_PI_4 / 2);
    [UIView animateWithDuration:anim.duration animations:^{
        pictureView.alpha = .5;
        pictureView.transform = tran;
    }];
}

#pragma mark - 动画代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UIView *view = [anim valueForKey:addGoodAnimKey];
    [view removeFromSuperview];
}

@end
