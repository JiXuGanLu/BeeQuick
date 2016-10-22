//
//  YBZYHomeHotGoodView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/22.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYHomeHotGoodView.h"
#import "YBZYHomeHotGoodViewFlowLayout.h"
#import "YBZYHomeHotGoodViewCell.h"

static NSString *hotGoodCellId = @"hotGoodCellId";

static NSString *animPictureViewKey = @"animPictureViewKey";

@interface YBZYHomeHotGoodView () <UICollectionViewDelegate, UICollectionViewDataSource, YBZYHomeHotGoodViewCellDelegate, CAAnimationDelegate>

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

#pragma mark - collectionview代理和数据源

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBZYHomeHotGoodViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotGoodCellId forIndexPath:indexPath];
    YBZYGoodModel *model = self.goodModels[indexPath.row];
    cell.goodModel = model;
    cell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:model.id userId:YBZYUserId].lastObject[@"count"] integerValue];
    cell.delegate = self;
    return cell;
}

#pragma mark - cell代理

- (void)didClickPictureInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell {
    YBZYGoodWebViewController *goodWebVC = [[YBZYGoodWebViewController alloc] init];
    goodWebVC.goodModel = homeHotGoodViewCell.goodModel;
    
    [self.superViewController.navigationController pushViewController:goodWebVC animated:true];
}

- (void)didClickAddButtonInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell {
    [[YBZYSQLiteManager sharedManager] addGood:homeHotGoodViewCell.goodModel withId:homeHotGoodViewCell.goodModel.id userId:YBZYUserId goodsType:homeHotGoodViewCell.goodModel.goods_type];
    
    homeHotGoodViewCell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:homeHotGoodViewCell.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
    
    CGPoint startPoint = [homeHotGoodViewCell convertPoint:homeHotGoodViewCell.pictureView.center toView:self.window];
    CGPoint endPoint = [self.window convertPoint:CGPointMake(YBZYScreenWidth / 10 * 7, YBZYScreenHeight - 40) toView:self.window];
    CAKeyframeAnimation *anim = [[CAKeyframeAnimation alloc] init];
    anim.keyPath = @"position";
    anim.duration = .9;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(startPoint.x + 40, startPoint.y - 40)];
    anim.path = path.CGPath;
    anim.delegate = self;
    
    UIImageView *animPictureView = [[UIImageView alloc] initWithImage:homeHotGoodViewCell.pictureView.image];
    animPictureView.frame = homeHotGoodViewCell.pictureView.frame;
    CGAffineTransform tran = homeHotGoodViewCell.pictureView.transform;
    animPictureView.transform = tran;
    [self.window addSubview:animPictureView];
    [anim setValue:animPictureView forKey:animPictureViewKey];
    [animPictureView.layer addAnimation:anim forKey:nil];
    tran = CGAffineTransformMakeScale(.1, .1);
    tran = CGAffineTransformRotate(tran, M_PI_4 + M_PI_4 / 2);
    [UIView animateWithDuration:anim.duration animations:^{
        animPictureView.alpha = .5;
        animPictureView.transform = tran;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UIView *view = [anim valueForKey:animPictureViewKey];
    [view removeFromSuperview];
}

- (void)didClickReduceButtonInHomeHotGoodViewCell:(YBZYHomeHotGoodViewCell *)homeHotGoodViewCell {
    [[YBZYSQLiteManager sharedManager] reduceGoodWithId:homeHotGoodViewCell.goodModel.id userId:YBZYUserId];
    homeHotGoodViewCell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:homeHotGoodViewCell.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
}

@end
