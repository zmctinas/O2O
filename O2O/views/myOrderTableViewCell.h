//
//  myOrderTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/24.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"
#import "orderModel.h"
#import "couponModel.h"

@interface myOrderTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timetyoe;


@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property(strong,nonatomic)orderModel* orderModel;

@property(strong,nonatomic)couponModel* coupModel;

- (IBAction)rightBtn:(UIButton *)sender;

- (IBAction)leftBtn:(UIButton *)sender;


@end
