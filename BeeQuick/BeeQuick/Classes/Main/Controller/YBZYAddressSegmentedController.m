//
//  YBZYAddressSegmentedController.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressSegmentedController.h"
#import "UINavigationBar+YBZY.h"

@interface YBZYAddressSegmentedController ()

@property (nonatomic, weak) UIView *addressView;

@property (nonatomic, weak) UIView *pickUpView;

@end

@implementation YBZYAddressSegmentedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar ybzy_setBackgroundColor:YBZYCommonYellowColor];
    self.navigationController.navigationBar.translucent = false;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar ybzy_reset];
}

- (void)setupUI {
    self.view.backgroundColor = YBZYCommonBackgroundColor;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"送货上门",@"店铺自提"]];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:YBZYCommonSmallFont,
                                             NSForegroundColorAttributeName:YBZYCommonDarkTextColor};
    [segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:YBZYCommonSmallFont,
                                               NSForegroundColorAttributeName:YBZYCommonMidTextColor};
    [segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [segmentedControl setTintColor:[UIColor whiteColor]];
    [segmentedControl setSelectedSegmentIndex:self.selectedIndex];
    [segmentedControl addTarget:self action:@selector(switchAddressType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    YBZYAddressController *addressController = [[YBZYAddressController alloc] init];
    addressController.isLoactionHidden = self.isAddressLocateHidden;
    [self.view addSubview:addressController.view];
    [self addChildViewController:addressController];
    [addressController didMoveToParentViewController:self];
    self.addressView = addressController.view;
    
    YBZYPickUpController *pickUpController = [[YBZYPickUpController alloc] init];
    [self.view addSubview:pickUpController.view];
    [self addChildViewController:pickUpController];
    [pickUpController didMoveToParentViewController:self];
    self.pickUpView = pickUpController.view;
    
    [addressController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [pickUpController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.selectedIndex) {
        self.addressView.hidden = true;
        self.pickUpView.hidden = false;
    } else {
        self.addressView.hidden = false;
        self.pickUpView.hidden = true;
    }
}

- (void)switchAddressType:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.addressView.hidden = false;
        self.pickUpView.hidden = true;
    } else {
        self.addressView.hidden = true;
        self.pickUpView.hidden = false;
    }
}

@end
