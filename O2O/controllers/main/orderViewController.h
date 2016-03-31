//
//  orderViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/12.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderViewController : fatherViewController

@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* gid;
@property(copy,nonatomic)NSString* num;
@property(copy,nonatomic)NSArray* attSource;
@property(copy,nonatomic)NSDictionary* messageDic;
@property(copy,nonatomic)NSString* jsonStr;

@property (weak, nonatomic) IBOutlet UILabel *zongjiaLabel;

@property (strong, nonatomic) IBOutlet  UIButton *youhuiBtn;

- (IBAction)couponBtn:(UIButton *)sender;



@end
