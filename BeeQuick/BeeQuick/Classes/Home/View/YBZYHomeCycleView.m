//
//  YBZYHomeCycleView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeCycleView.h"
#import "YBZYHomeCycleViewFlowLayout.h"
#import "YBZYHomeCycleViewCell.h"

static NSString *homeCycleCellId = @"homeCycleCellId";

@interface YBZYHomeCycleView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<YBZYHomeCategoryActivityModel *> *activityModels;
@property (nonatomic, strong) NSArray<NSURL *> *imageURLs;
@property (nonatomic, weak) UIPageControl *cyclePageControl;
@property (nonatomic, weak) UICollectionView *cycleImageView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YBZYHomeCycleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self loadActivityData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    YBZYHomeCycleViewFlowLayout *flowLayout = [[YBZYHomeCycleViewFlowLayout alloc] init];
    UICollectionView *cycleImageView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    cycleImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cycleImageView];
    cycleImageView.pagingEnabled = YES;
    cycleImageView.bounces = NO;
    cycleImageView.showsVerticalScrollIndicator = NO;
    cycleImageView.showsHorizontalScrollIndicator = NO;
    cycleImageView.delegate = self;
    cycleImageView.dataSource = self;
    
    self.cycleImageView = cycleImageView;
    [cycleImageView registerClass:[YBZYHomeCycleViewCell class] forCellWithReuseIdentifier:homeCycleCellId];
    
    UIPageControl *cyclePageControl = [[UIPageControl alloc] init];
    [self addSubview:cyclePageControl];
    [cyclePageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.offset(0);
    }];
    cyclePageControl.pageIndicatorTintColor = YBZYCommonLightTextColor;
    cyclePageControl.currentPageIndicatorTintColor = YBZYCommonYellowColor;
    cyclePageControl.userInteractionEnabled = NO;
    self.cyclePageControl = cyclePageControl;
}

- (void)loadActivityData {
    NSString *urlString = @"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickHomeFocus.json";
    [[YBZYHTTPSessionManager sharedSessionManager] requestMethod:YBZYHTTPMethodGet URLString:urlString parameters:nil completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSArray *act_rows = ((NSDictionary *)response)[@"act_rows"];
        NSMutableArray *activityModels = [NSMutableArray array];
        for (NSDictionary *dict in act_rows) {
            NSDictionary *activity = dict[@"activity"];
            [activityModels addObject:[YBZYHomeCategoryActivityModel yy_modelWithDictionary:activity]];
        }
        self.activityModels = activityModels.copy;
    }];
}

- (void)setActivityModels:(NSArray<YBZYHomeCategoryActivityModel *> *)activityModels {
    _activityModels = activityModels;
    
    NSMutableArray<NSURL *> *imageURLs = [NSMutableArray array];
    for (YBZYHomeCategoryActivityModel *model in activityModels) {
        [imageURLs addObject:[NSURL URLWithString:model.img]];
    }
    self.imageURLs = imageURLs.copy;
    self.cyclePageControl.numberOfPages = imageURLs.count;
    [self.cycleImageView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:imageURLs.count * 100 inSection:0];
    [self.cycleImageView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        _timer = timer;
    }
    return _timer;
}

- (void)updateTimer {
    NSIndexPath *indexPath = self.cycleImageView.indexPathsForVisibleItems[0];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0];
    [self.cycleImageView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //下面这个减速完成的方法,在默认情况下只有手动滑动的时候才调用,如果想让系统自己每次滑动的结束后也调用,需要在动画结束的方法内部手动调用此方法.
    [self scrollViewDidEndDecelerating:self.cycleImageView];
}

//监听用户手动滚动的减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentRow = offsetX / self.bounds.size.width;
    if (currentRow == 0) {
        [self.cycleImageView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageURLs.count * 100 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:NO];
    } else if (currentRow == self.imageURLs.count * 200 - 1) {
        [self.cycleImageView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageURLs.count * 100 - 1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //更新页码
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentPage = (NSInteger)(offsetX / self.bounds.size.width + .5);
    NSInteger pcPage = currentPage % self.imageURLs.count;
    self.cyclePageControl.currentPage = pcPage;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLs.count * 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYHomeCycleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCycleCellId forIndexPath:indexPath];
    cell.imageURL = self.imageURLs[indexPath.row % self.imageURLs.count];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYActivityWebViewController *actWebVC = [[YBZYActivityWebViewController alloc] init];
    actWebVC.urlString = self.activityModels[indexPath.row % self.imageURLs.count].urlString;
    actWebVC.title = self.activityModels[indexPath.row % self.imageURLs.count].name;
    
    if ([self.delegate respondsToSelector:@selector(pushAssignedViewcontroller:)]) {
        [self.delegate pushAssignedViewcontroller:actWebVC];
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.timer invalidate];
}

@end
