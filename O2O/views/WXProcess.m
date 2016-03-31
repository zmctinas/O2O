//
//  WXProcess.m
//  O2O
//
//  Created by wangxiaowei on 15/6/8.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "WXProcess.h"
#import "AppDelegate.h"

@implementation WXProcess

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


    

#pragma mark - getter

-(UIActivityIndicatorView*)activity
{
    if (_activity == nil) {
        _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        
        _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _activity.hidesWhenStopped = YES;
        _activity.center = self.center;
    }
    
    return _activity;
}

-(UIView*)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _backView.center = self.center;
        _backView.backgroundColor = [UIColor blackColor];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
        _backView.alpha = 0.7;
    }
    return _backView;
}

-(void)start
{
    UIApplication* app = [UIApplication sharedApplication];
    AppDelegate* delegate = app.delegate;
    [delegate.window addSubview:self];
    
    self.frame = [[self superview] frame];
    [self addSubview:self.backView];
    [self addSubview:self.activity];
    [_activity startAnimating];
}

-(void)stop
{
    [_activity stopAnimating];
    [self removeFromSuperview];
}

@end
