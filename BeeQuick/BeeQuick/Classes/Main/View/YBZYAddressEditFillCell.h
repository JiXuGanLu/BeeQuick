//
//  YBZYAddressEditFillCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBZYCityGroupModel.h"

@interface YBZYAddressEditFillCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *placeHolderString;

@property (nonatomic, copy) NSString *originalString;

@property (nonatomic, assign) UIKeyboardType keyboardType;

@property (nonatomic, copy) void(^inputBlock)(NSString *inputString);

@property (nonatomic, assign) BOOL isPickerInput;

@property (nonatomic, strong) NSArray<YBZYCityGroupModel *> *cityGroups;

@end
