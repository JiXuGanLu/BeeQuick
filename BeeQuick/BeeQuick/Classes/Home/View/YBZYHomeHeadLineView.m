//
//  YBZYHomeHeadLineView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeHeadLineView.h"
#import "YBZYHomeHeadLineModel.h"
#import "YBZYHomeHeadLineViewFlowLayout.h"
#import "YBZYHomeHeadLineViewCell.h"
#import "YBZYHomeCategoryActivityModel.h"

static NSString *homeHeadLineCellId = @"homeHeadLineCellId";

static CGFloat margin = 8;

@interface YBZYHomeHeadLineView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<YBZYHomeHeadLineModel *> *headLineModels;

@property (nonatomic, weak) UICollectionView *headLineView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray<YBZYHomeCategoryActivityModel *> *activityModels;

@end

@implementation YBZYHomeHeadLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self loadHeadLineData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat imageViewW = YBZYScreenWidth / 5;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_v4_headLine"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(margin);
        make.bottom.offset(-margin);
        make.width.offset(imageViewW - 2 * margin);
    }];
    
    UIView *spareLine = [[UIView alloc] init];
    spareLine.backgroundColor = [UIColor ybzy_colorWithHex:0xeeeeee];
    [self addSubview:spareLine];
    [spareLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.height.equalTo(self).offset(-10);
        make.top.offset(5);
        make.left.equalTo(imageView.mas_right).offset(8);
    }];
    
    YBZYHomeHeadLineViewFlowLayout *flowLayout = [[YBZYHomeHeadLineViewFlowLayout alloc] init];
    UICollectionView *headLineView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    headLineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headLineView];
    self.headLineView = headLineView;
    [headLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.left.equalTo(spareLine.mas_right);
    }];
    headLineView.pagingEnabled = YES;
    headLineView.bounces = NO;
    headLineView.showsVerticalScrollIndicator = NO;
    headLineView.showsHorizontalScrollIndicator = NO;
    headLineView.delegate = self;
    headLineView.dataSource = self;
    [headLineView registerClass:[YBZYHomeHeadLineViewCell class] forCellWithReuseIdentifier:homeHeadLineCellId];
}

- (void)loadHeadLineData {
    NSString *urlString = @"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickHomeHeadLine.json";
    [[YBZYHTTPSessionManager sharedSessionManager] requestMethod:YBZYHTTPMethodGet URLString:urlString parameters:nil completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSArray *act_rows = response[@"act_rows"];
        NSMutableArray *activityModels = [NSMutableArray array];
        NSMutableArray *headLineModels = [NSMutableArray array];
        for (NSDictionary *dict in act_rows) {
            NSDictionary *activity = dict[@"activity"];
            [activityModels addObject:[YBZYHomeCategoryActivityModel yy_modelWithDictionary:activity]];
            NSDictionary *headline_detail = dict[@"headline_detail"];
            [headLineModels addObject:[YBZYHomeHeadLineModel yy_modelWithDictionary:headline_detail]];
        }
        self.activityModels = activityModels.copy;
        self.headLineModels = headLineModels.copy;
    }];
}

- (void)setHeadLineModels:(NSArray<YBZYHomeHeadLineModel *> *)headLineModels {
    _headLineModels = headLineModels;
    [self.headLineView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:headLineModels.count * 200 inSection:0];
    [self.headLineView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        _timer = timer;
    }
    return _timer;
}

- (void)updateTimer {
    NSIndexPath *indexPath = self.headLineView.indexPathsForVisibleItems[0];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0];
    [self.headLineView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:0 animated:true];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //下面这个减速完成的方法,在默认情况下只有手动滑动的时候才调用,如果想让系统自己每次滑动的结束后也调用,需要在动画结束的方法内部手动调用此方法.
    [self scrollViewDidEndDecelerating:self.headLineView];
}

//监听用户手动滚动的减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentRow = offsetX / self.bounds.size.width;
    if (currentRow == 0) {
        [self.headLineView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.headLineModels.count * 200 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    } else if (currentRow == self.headLineModels.count * 400 - 1) {
        [self.headLineView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.headLineModels.count * 200 - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.headLineModels.count * 400;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYHomeHeadLineViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeHeadLineCellId forIndexPath:indexPath];
    cell.headLineModel = self.headLineModels[indexPath.row % self.headLineModels.count];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYActivityWebViewController *actWebVC = [[YBZYActivityWebViewController alloc] init];
    actWebVC.urlString = self.activityModels[indexPath.row % self.headLineModels.count].urlString;
    actWebVC.title = self.activityModels[indexPath.row % self.headLineModels.count].name;
    
    [self.superViewController.navigationController pushViewController:actWebVC animated:true];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.timer invalidate];
}

@end
