//
//  YBZYNewVersionView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/20.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYNewVersionView.h"

@interface YBZYNewVersionView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation YBZYNewVersionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self loadScrollView];
    [self loadPageControl];
    [self loadImageNames];
}

- (void)loadScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.bounds;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
}

- (void)loadPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = YBZYCommonYellowColor;
    pageControl.hidesForSinglePage = YES;
    self.pageControl = pageControl;
    [self addSubview:pageControl];
    CGFloat bottomMargin = -10;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.offset(bottomMargin);
    }];
}

- (void)loadImageNames {
    NSMutableArray *imageNames = [NSMutableArray array];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.height > 960) {
        for (int i = 0; i < 3; i++) {
            NSString *imageName = [NSString stringWithFormat:@"guide_40_%zd", i + 1];
            [imageNames addObject:imageName];
        }
    } else {
        for (int i = 0; i < 3; i++) {
            NSString *imageName = [NSString stringWithFormat:@"guide_35_%zd", i + 1];
            [imageNames addObject:imageName];
        }
    }
    self.imageNames = imageNames.copy;
}

- (void)setImageNames:(NSArray *)imageNames {
    _imageNames = imageNames;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * imageNames.count, self.scrollView.bounds.size.height);
    for (int i = 0; i < imageNames.count; i++) {
        UIImage *image = [UIImage imageNamed:imageNames[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectOffset(self.frame, self.bounds.size.width * i, 0);
        [self.scrollView addSubview:imageView];
        if (i == imageNames.count - 1) {
            imageView.userInteractionEnabled = true;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendSwitchRootViewControllerNotification)];
            [imageView addGestureRecognizer:tapGes];
        }
    }
    self.pageControl.numberOfPages = imageNames.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = (NSInteger)(scrollView.contentOffset.x / self.bounds.size.width + 0.5);
    self.pageControl.currentPage = currentPage;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)sendSwitchRootViewControllerNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:YBZYSwitchRootViewControllerNotification object:nil];
}

@end
