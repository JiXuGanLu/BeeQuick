//
//  YBZYHomeHotGoodView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeHotGoodView.h"
#import "YBZYHomeHotGoodViewFlowLayout.h"

NSString * const YBZYHomeHotGoodViewRefreshNotification = @"YBZYHomeHotGoodViewRefreshNotification";

static NSString *hotGoodCellId = @"hotGoodCellId";

@interface YBZYHomeHotGoodView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *hotGoodView;

@property (nonatomic, strong) NSArray<YBZYGoodModel *> *goodModels;

@end

@implementation YBZYHomeHotGoodView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodView:) name:YBZYHomeHotGoodViewRefreshNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadHotGoodData) name:YBZYHomeRefreshNotification object:nil];
    
    YBZYHomeHotGoodViewFlowLayout *flowLayout = [[YBZYHomeHotGoodViewFlowLayout alloc] init];
    UICollectionView *hotGoodView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    hotGoodView.backgroundColor = YBZYCommonBackgroundColor;
    [self addSubview:hotGoodView];
    self.hotGoodView = hotGoodView;
    [hotGoodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    [hotGoodView registerClass:[YBZYHomeHotGoodViewCell class] forCellWithReuseIdentifier:hotGoodCellId];
    hotGoodView.delegate = self;
    hotGoodView.dataSource = self;
    hotGoodView.scrollEnabled = false;
    hotGoodView.showsVerticalScrollIndicator = false;
    [self loadHotGoodData];
}

- (void)loadHotGoodData {
    NSString *urlString = @"https://coding.net/u/YiBaZhuangYuan/p/BeeQuickData/git/raw/master/BeeQuickHomeHot.json";
    
    [[YBZYHTTPSessionManager sharedSessionManager] requestMethod:YBZYHTTPMethodGet URLString:urlString parameters:nil completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        
        self.goodModels = [NSArray yy_modelArrayWithClass:[YBZYGoodModel class] json:response[@"data"]];
        CGFloat hotGoodViewHeight = (NSUInteger)((self.goodModels.count + 1) / 2) * 261;
        [self.hotGoodView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(hotGoodViewHeight);
        }];
        [self.hotGoodView layoutIfNeeded];
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYHomeTableFooterViewUpdateNotification object:nil userInfo:@{@"height" : @(hotGoodViewHeight)}];
        [self.hotGoodView reloadData];
    }];
}

- (void)refreshGoodView:(NSNotification *)sender {
    [self.hotGoodView reloadData];
}

#pragma mark - collectionview代理和数据源

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYHomeHotGoodViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotGoodCellId forIndexPath:indexPath];
    YBZYGoodModel *model = self.goodModels[indexPath.row];
    cell.goodModel = model;
    cell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:model.id userId:YBZYUserId].lastObject[@"count"] integerValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.delegate = self.superViewController;
    });
    return cell;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
