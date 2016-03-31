//
//  credetialViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "allMerModel.h"
#import "goodsViewController.h"

@interface credetialViewController : fatherViewController<changeAddressDelegate>

@property(strong,nonatomic)allMerModel* model;

@property(copy,nonatomic)NSString* inteID;

@end
