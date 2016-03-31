//
//  explainViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/7/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "explainViewController.h"

@interface explainViewController ()
{
    UIWebView* webView;
}

@property(strong,nonatomic)UILabel* label;

@end

@implementation explainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.backgroundColor = [UIColor whiteColor];
    NSURL* url = [NSURL URLWithString:CREDITECARD_WEB];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    
    // Do any additional setup after loading the view from its nib.
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

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        _label.text = @"会员卡说明";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:15];
    }
    return _label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
