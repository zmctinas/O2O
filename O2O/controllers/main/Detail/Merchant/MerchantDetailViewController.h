//
//  MerchantDetailViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "commerModel.h"

@interface MerchantDetailViewController : fatherViewController

@property(strong,nonatomic)commerModel* model;

@property(copy,nonatomic)NSString* comID;



@end
