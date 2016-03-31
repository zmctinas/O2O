//
//  evaluateViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/5.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentStar.h"
#import "orderModel.h"
#import "couponModel.h"

@interface evaluateViewController : fatherViewController

@property(strong,nonatomic)orderModel* model;
@property (strong, nonatomic) IBOutlet UIView *backScrollView;
@property (strong, nonatomic) IBOutlet UIView *conView;

@property(strong,nonatomic)couponModel* couModel;

@property(assign,nonatomic)NSInteger selectType;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *salePrice;
@property (weak, nonatomic) IBOutlet commentStar *starLabel;

@end
