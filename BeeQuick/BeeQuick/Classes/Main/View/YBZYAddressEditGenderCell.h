//
//  YBZYAddressEditGenderCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZYAddressEditGenderCell : UITableViewCell

@property (nonatomic, copy) void(^genderBlock)(NSString *gender);

@property (nonatomic, copy) NSString *originalGender;

@end
