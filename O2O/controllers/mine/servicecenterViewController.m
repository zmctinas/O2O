//
//  servicecenterViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/7/6.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "servicecenterViewController.h"

@interface servicecenterViewController ()
{
    UIWebView* webView;
}
@property(strong,nonatomic)UILabel* label;
@end

@implementation servicecenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = self.label;
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SERVICE_WEB]]];
    [self.view addSubview:webView];
    
    // Do any additional setup after loading the view.
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
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"服务中心";
        _label.font = [UIFont boldSystemFontOfSize:17];
        
    }
    
    return _label;
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