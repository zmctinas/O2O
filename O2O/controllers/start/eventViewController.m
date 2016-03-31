//
//  eventViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "eventViewController.h"
#import "startViewController.h"
#import "AppDelegate.h"

@interface eventViewController ()<UIScrollViewDelegate>

@end

@implementation eventViewController
{
    UIPageControl* pagecontrol;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    for (int i = 0 ; i < 3; i++) {
        NSString* imageName = [NSString stringWithFormat:@"活动页%i",i+ 1];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        if (i == 2) {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            [imageView addSubview:button];
            imageView.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(changeRoot) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;

    [self.view addSubview:scrollView];
    
    pagecontrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, 60, 20)];
    pagecontrol.center = CGPointMake(scrollView.center.x, pagecontrol.center.y);
    pagecontrol.numberOfPages = 3;
    pagecontrol.currentPage = 0;
    
    [self.view addSubview:pagecontrol];
    
    // Do any additional setup after loading the view.
}

-(void)changeRoot
{
    NSString* isFirst = @"yes";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:isFirst forKey:@"isfirst"];
    [defaults synchronize];
    
    startViewController* start = [[startViewController alloc]init];
    UIApplication* app = [UIApplication sharedApplication];
    AppDelegate* delegate = app.delegate;
    delegate.window.rootViewController = start;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger num = scrollView.contentOffset.x / SCREEN_WIDTH;
    pagecontrol.currentPage = num;
}


@end
