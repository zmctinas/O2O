//
//  rechargeViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rechargeViewController : fatherViewController

@property(copy,nonatomic)NSString* ordernum;

- (IBAction)textField:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *balance;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)payStyleBtn:(UIButton *)sender;

- (IBAction)goBuy:(UIButton *)sender;

@end
