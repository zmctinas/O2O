//
//  notifiViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WXMinecouponType,
    WXMineNotifierType,
}WXMineCategory;

@interface notifiViewController : fatherViewController

@property(nonatomic)WXMineCategory type;

@end
