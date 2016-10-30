//
//  YBZYAddressSelectCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZYAddressSelectCell;

@protocol YBZYAddressSelectCellDelegate <NSObject>

- (void)addressSelectCell:(YBZYAddressSelectCell *)cell didClickEditButtonToEditAddress:(YBZYAddressModel *)addressModel;

@end

@interface YBZYAddressSelectCell : UITableViewCell

@property (nonatomic, strong) YBZYAddressModel *addressModel;

@property (nonatomic, weak) id<YBZYAddressSelectCellDelegate> delegate;

@property (nonatomic, assign) BOOL isCurrentAddress;

@end
