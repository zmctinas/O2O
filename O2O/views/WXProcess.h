//
//  WXProcess.h
//  O2O
//
//  Created by wangxiaowei on 15/6/8.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXProcess : UIView

@property(strong,nonatomic)UIActivityIndicatorView* activity;
@property(strong,nonatomic)UIView* backView;

-(void)start;

-(void)stop;

@end
