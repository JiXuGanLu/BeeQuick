//
//  YBZYMineGoodCollectionController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/31.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYMineGoodCollectionController.h"
#import "YBZYSuperMarketGoodCell.h"

static NSString *goodCellId = @"goodCellId";

@interface YBZYMineGoodCollectionController () <UITableViewDelegate, UITableViewDataSource, YBZYSuperMarketGoodCellDelegate>

@property (nonatomic, weak) UITableView *collectionGoodView;
@property (nonatomic, strong) NSArray<YBZYGoodModel *> *collectionGoods;

@end

@implementation YBZYMineGoodCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
}

- (void)setupUI {
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    self.title = @"商品收藏";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImageView *noGoodLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2_goods_empty"]];
    [self.view addSubview:noGoodLogo];
    
    UILabel *noGoodLabel = [UILabel ybzy_labelWithText:@"没有收藏的商品" andTextColor:YBZYCommonMidTextColor andFontSize:14];
    noGoodLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noGoodLabel];
    
    [noGoodLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
        make.width.height.offset(90);
    }];
    
    [noGoodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(noGoodLogo.mas_bottom).offset(20);
    }];
    
    UITableView *collectionGoodView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    collectionGoodView.backgroundColor = YBZYCommonBackgroundColor;
    collectionGoodView.showsVerticalScrollIndicator = false;
    collectionGoodView.showsHorizontalScrollIndicator = false;
    collectionGoodView.delegate = self;
    collectionGoodView.dataSource = self;
    collectionGoodView.rowHeight = 90;
    [self.view addSubview:collectionGoodView];
    self.collectionGoodView = collectionGoodView;
    collectionGoodView.hidden = true;
    
    [collectionGoodView registerClass:[YBZYSuperMarketGoodCell class] forCellReuseIdentifier:goodCellId];
}

#pragma mark - tableView数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectionGoods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBZYSuperMarketGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:goodCellId forIndexPath:indexPath];
    YBZYGoodModel *model = self.collectionGoods[indexPath.row];
    cell.goodModel = model;
    NSArray<NSDictionary *> *shopCartData = [[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:model.id userId:YBZYUserId];
    cell.goodCount = [[shopCartData firstObject][@"count"] integerValue];
    cell.delegate = self;
    return cell;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.collectionGoodView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    YBZYGoodModel *model = self.collectionGoods[indexPath.row];
    [[YBZYSQLiteManager sharedManager] deleteCollectionGoodWithId:model.id userId:YBZYUserId];
    [tableView reloadData];
}

#pragma mark - cell代理

- (void)didClickAddButtonInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell {
    [[YBZYSQLiteManager sharedManager] addGood:superMarketGoodCell.goodModel withId:superMarketGoodCell.goodModel.id userId:YBZYUserId goodsType:superMarketGoodCell.goodModel.goods_type];
    superMarketGoodCell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:superMarketGoodCell.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
}

- (void)didClickReduceButtonInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell {
    [[YBZYSQLiteManager sharedManager] reduceGoodWithId:superMarketGoodCell.goodModel.id userId:YBZYUserId];
    superMarketGoodCell.goodCount = [[[YBZYSQLiteManager sharedManager] getGoodInShopCartWithGoodId:superMarketGoodCell.goodModel.id userId:YBZYUserId].firstObject[@"count"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYAddOrReduceGoodNotification object:nil];
}

- (void)didClickPictureInSuperMarketGoodCell:(YBZYSuperMarketGoodCell *)superMarketGoodCell {
    YBZYGoodWebViewController *goodWebVC = [[YBZYGoodWebViewController alloc] init];
    goodWebVC.goodModel = superMarketGoodCell.goodModel;
    [self.navigationController pushViewController:goodWebVC animated:true];
}

- (NSArray<YBZYGoodModel *> *)collectionGoods {
    NSArray<NSDictionary *> *goodData = [[YBZYSQLiteManager sharedManager] getCollectionGoodsWithUserId:YBZYUserId];
    if (goodData.count == 0) {
        self.collectionGoodView.hidden = true;
    } else {
        self.collectionGoodView.hidden = false;
    }
    NSMutableArray *collectionGoods = [NSMutableArray array];
    for (NSDictionary *dict in goodData) {
        [collectionGoods addObject:dict[@"goodModel"]];
    }
    return collectionGoods.copy;
}

@end
