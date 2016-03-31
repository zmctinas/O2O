//
//  formyViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/6/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "formyViewController.h"

@interface formyViewController ()

@property(strong,nonatomic)UILabel* label;


@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation formyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSURL* url = [NSURL URLWithString:MY_WEB];
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

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        _label.text = @"关于我们";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:15];
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
