//
//  sweepWebViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/7/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "fatherViewController.h"

@interface sweepWebViewController : fatherViewController

@property(copy,nonatomic)NSString* urlStr;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end
