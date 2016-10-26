//
//  YBZYHomeIconView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/21.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeIconView.h"
#import "YBZYHomeIconViewFlowLayout.h"
#import "YBZYHomeIconViewCell.h"
#import "YBZYHomeCategoryActivityModel.h"

static NSString *homeIconViewCellId = @"homeIconViewCellId";

@interface YBZYHomeIconView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<YBZYHomeCategoryActivityModel *> *activityModels;

@property (nonatomic, weak) UICollectionView *iconView;

@end

@implementation YBZYHomeIconView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self loadActivityData];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self loadActivityData];
}

- (void)setupUI {
    YBZYHomeIconViewFlowLayout *flowLayout = [[YBZYHomeIconViewFlowLayout alloc] init];
    
    UICollectionView *iconView =
    [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    iconView.backgroundColor = [UIColor whiteColor];
    [iconView registerClass:[YBZYHomeIconViewCell class] forCellWithReuseIdentifier:homeIconViewCellId];
    [self addSubview:iconView];
    self.iconView = iconView;
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    iconView.showsVerticalScrollIndicator = NO;
    iconView.showsHorizontalScrollIndicator = NO;
    iconView.dataSource = self;
    iconView.delegate = self;
    iconView.bounces = NO;
}

- (void)loadActivityData {
    NSString *urlString = @"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickHomeIcon.json";
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
        [self.iconView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.activityModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYHomeIconViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:homeIconViewCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.activityModel = self.activityModels[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYActivityWebViewController *actWebVC = [[YBZYActivityWebViewController alloc] init];
    actWebVC.urlString = self.activityModels[indexPath.row].urlString;
    actWebVC.title = self.activityModels[indexPath.row].name;
    
    if ([self.delegate respondsToSelector:@selector(pushAssignedViewcontroller:)]) {
        [self.delegate pushAssignedViewcontroller:actWebVC];
    }
}

@end
