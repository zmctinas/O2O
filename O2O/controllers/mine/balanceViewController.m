//
//  balanceViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "balanceViewController.h"

@interface balanceViewController ()
{
    NSUserDefaults* defaults;
}

@property(strong,nonatomic)UILabel* label;

@end

@implementation balanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _iconView.layer.cornerRadius  = 3;
    _iconView.layer.masksToBounds = YES;
    
    self.navigationItem.titleView = self.label;
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString* money = [defaults objectForKey:@"money"];
    _balance.text = [NSString stringWithFormat:@"￥%0.2f",money.floatValue];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"会员卡余额";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


@end
