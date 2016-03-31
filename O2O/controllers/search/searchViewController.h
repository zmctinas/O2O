//
//  searchViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchprotocolDelegate <NSObject>

-(void)getSearchMessage:(NSString*)message;

@end

@interface searchViewController : fatherViewController

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;


@property(assign,nonatomic)id<searchprotocolDelegate> delegate;

@end
