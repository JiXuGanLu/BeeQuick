//
//  YBZYCheckOutPayMethodCell.h
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/25.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YBZYCheckOutPayMethod) {
    YBZYCheckOutPayMethodALiPay = 0,
    YBZYCheckOutPayMethodWeChatPay,
    YBZYCheckOutPayMethodQQPay,
    YBZYCheckOutPayMethodCODPay
};

@interface YBZYCheckOutPayMethodCell : UITableViewCell

@property (nonatomic, assign) YBZYCheckOutPayMethod payMethod;

@property (nonatomic, assign) BOOL payMethodSelected;

@end
