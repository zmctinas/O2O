//
//  tabbarViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/7/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tabbarViewController : UITabBarController

@property(strong,nonatomic)UIView* backView;

-(void)tapIndex:(UIButton*)sender;

@end
