//
//  groupTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/9/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"
#import "couponModel.h"

@interface groupTableViewCell : rootTableViewCell

@property(strong,nonatomic)couponModel* coupModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *timetyoe;


@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;


- (IBAction)rightBtn:(UIButton *)sender;

- (IBAction)leftBtn:(UIButton *)sender;

@end
