//
//  groupTicketViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupTicketViewController : fatherViewController

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property(strong,nonatomic)NSString* act;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;



- (IBAction)navBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@property (weak, nonatomic) IBOutlet UIButton *sencondBtn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@end
