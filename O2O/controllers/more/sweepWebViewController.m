//
//  sweepWebViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/7/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "sweepWebViewController.h"

@interface sweepWebViewController ()

@end

@implementation sweepWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL* url = [NSURL URLWithString:_urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
