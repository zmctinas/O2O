//
//  myOrderViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/24.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WXMyOrderAll,
    WXMyOrderUnPay,
    WXMyOrderUnSend,
    WXMyOrderUnReceive,
    WXMyOrderUnEvaluate,
}WXMyOrder;

@interface myOrderViewController : fatherViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;


@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifBtn;


@property(copy,nonatomic)NSString* act;

@property(nonatomic)WXMyOrder type;

@end
