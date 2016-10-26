//
//  YBZYHomeMainActivityView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeMainActivityView.h"
#import "YBZYHomeMainActivityViewCell.h"
#import "YBZYHomeMainActivityViewFlowLayout.h"

static NSString *mainActivityCellId = @"mainActivityCellId";

@interface YBZYHomeMainActivityView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainActivityView;

@property (nonatomic, strong) NSArray<YBZYHomeCategoryActivityModel *> *activityModels;

@end

@implementation YBZYHomeMainActivityView

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
    
    YBZYHomeMainActivityViewFlowLayout* flowLayout = [[YBZYHomeMainActivityViewFlowLayout alloc] init];
    UICollectionView* mainActivityView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    mainActivityView.backgroundColor = YBZYCommonBackgroundColor;
    [self addSubview:mainActivityView];
    self.mainActivityView = mainActivityView;
    [mainActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [mainActivityView registerClass:[YBZYHomeMainActivityViewCell class] forCellWithReuseIdentifier:mainActivityCellId];
    mainActivityView.showsVerticalScrollIndicator = NO;
    mainActivityView.showsHorizontalScrollIndicator = NO;
    mainActivityView.bounces = NO;
    mainActivityView.dataSource = self;
    mainActivityView.delegate = self;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activityModels.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath{
    YBZYHomeMainActivityViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:mainActivityCellId forIndexPath:indexPath];
    cell.activityModel = self.activityModels[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{    
    YBZYActivityWebViewController *actWebVC = [[YBZYActivityWebViewController alloc] init];
    actWebVC.urlString = self.activityModels[indexPath.row].urlString;
    actWebVC.title = self.activityModels[indexPath.row].name;
    
    if ([self.delegate respondsToSelector:@selector(pushAssignedViewcontroller:)]) {
        [self.delegate pushAssignedViewcontroller:actWebVC];
    }
}


- (void)loadActivityData {
    NSString *urlString = @"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickHomeActivities.json";
    
    [[YBZYHTTPSessionManager sharedSessionManager] requestMethod:YBZYHTTPMethodGet URLString:urlString parameters:nil completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSArray *act_rows = [response firstObject][@"act_rows"];
        NSMutableArray *activityModels = [NSMutableArray array];
        for (NSDictionary *dict in act_rows) {
            NSDictionary *activity = dict[@"activity"];
            [activityModels addObject:[YBZYHomeCategoryActivityModel yy_modelWithDictionary:activity]];
        }
        self.activityModels = activityModels.copy;
        [self.mainActivityView reloadData];
    }];
}

@end
