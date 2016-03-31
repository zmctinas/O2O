//
//  payHelpViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/6/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "payHelpViewController.h"

@interface payHelpViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation payHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付帮助";
    
    
    NSURL* url = [NSURL URLWithString:PAY_WEB];
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webview];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
