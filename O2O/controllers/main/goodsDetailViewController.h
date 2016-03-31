//
//  goodsDetailViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "allMerModel.h"
#import "WXMapViewController.h"

@interface goodsDetailViewController : fatherViewController

@property(strong,nonatomic)UIImage* image;

@property(copy,nonatomic)NSString* commid;

@property(strong,nonatomic)allMerModel* model;

@end
