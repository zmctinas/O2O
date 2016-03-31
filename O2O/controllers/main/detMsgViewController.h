//
//  detMsgViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/28.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detMsgViewController : fatherViewController

@property(copy,nonatomic)NSString* comid;

@property(assign,nonatomic)NSInteger offset;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;


@property (weak, nonatomic) IBOutlet UIButton *oneBtn;

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;

@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (weak, nonatomic) IBOutlet UIView *headBackView;


@end
