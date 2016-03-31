//
//  groupOrderViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupOrderViewController : fatherViewController

@property(copy,nonatomic)NSDictionary* messageDic;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *comNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *xiaojiLabel;

@property (weak, nonatomic) IBOutlet UIButton *youhuiBtn;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *zongjiaLabel;


@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

- (IBAction)numBtn:(UIButton *)sender;

- (IBAction)couponBtn:(UIButton *)sender;





@end
