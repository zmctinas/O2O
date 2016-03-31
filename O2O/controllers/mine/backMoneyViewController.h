//
//  backMoneyViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/7/3.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface backMoneyViewController : fatherViewController

@property(strong,nonatomic)NSString* totalMoney;

@property(copy,nonatomic)NSString* orderid;

@property (weak, nonatomic) IBOutlet UIView *hang1View;

@property (weak, nonatomic) IBOutlet UIView *hang2View;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
- (IBAction)tijiaoBtn:(UIButton *)sender;



@end
