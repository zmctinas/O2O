//
//  registerViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/14.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : fatherViewController

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;


- (IBAction)xieyiBtn:(UIButton *)sender;

@end
