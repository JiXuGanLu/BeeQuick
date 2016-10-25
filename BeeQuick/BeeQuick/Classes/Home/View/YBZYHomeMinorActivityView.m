//
//  YBZYHomeMinorActivityView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeMinorActivityView.h"
#import "YBZYHomeMinorActivityViewCell.h"
#import "YBZYHomeMinorActivityViewFlowLayout.h"

static NSString *minorActivityCellId = @"minorActivityCellId";

@interface YBZYHomeMinorActivityView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *minorActivityView;

@property (nonatomic, strong) NSArray<YBZYHomeCategoryActivityModel *> *activityModels;

@end

@implementation YBZYHomeMinorActivityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadActivityData];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    YBZYHomeMinorActivityViewFlowLayout* flowLayout = [[YBZYHomeMinorActivityViewFlowLayout alloc] init];
    UICollectionView* minorActivityView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    minorActivityView.backgroundColor = [UIColor whiteColor];
    [minorActivityView registerClass:[YBZYHomeMinorActivityViewCell class] forCellWithReuseIdentifier:minorActivityCellId];
    minorActivityView.showsVerticalScrollIndicator = NO;
    minorActivityView.showsHorizontalScrollIndicator = NO;
    minorActivityView.bounces = NO;
    minorActivityView.dataSource = self;
    minorActivityView.delegate = self;
    [self addSubview:minorActivityView];
    [minorActivityView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.offset(0);
    }];
    
    self.minorActivityView = minorActivityView;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activityModels.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath{
    YBZYHomeMinorActivityViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:minorActivityCellId forIndexPath:indexPath];
    cell.activityModel = self.activityModels[indexPath.row];
    
    return cell; 
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YBZYActivityWebViewController *actWebVC = [[YBZYActivityWebViewController alloc] init];
    actWebVC.urlString = self.activityModels[indexPath.row].urlString;
    actWebVC.title = self.activityModels[indexPath.row].name;
    
    [self.superViewController.navigationController pushViewController:actWebVC animated:true];
}


- (void)loadActivityData {
    NSString *urlString = @"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickHomeActivities.json";

    [[YBZYHTTPSessionManager sharedSessionManager] requestMethod:YBZYHTTPMethodGet URLString:urlString parameters:nil completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSArray *act_rows = [response lastObject][@"act_rows"];
        NSMutableArray *activityModels = [NSMutableArray array];
        for (NSDictionary *dict in act_rows) {
            NSDictionary *activity = dict[@"activity"];
            [activityModels addObject:[YBZYHomeCategoryActivityModel yy_modelWithDictionary:activity]];
        }
        self.activityModels = activityModels.copy;
        [self.minorActivityView reloadData];
    }];
}

@end
