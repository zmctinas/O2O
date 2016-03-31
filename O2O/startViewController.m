//
//  startViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "startViewController.h"
#import "mainViewController.h"
#import "AppDelegate.h"
#import "categoryViewController.h"
#import "MerGoodsViewController.h"
#import "moreViewController.h"
#import "mineViewController.h"
#import "tabbarViewController.h"

@interface startViewController ()

@end

@implementation startViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray* arr = @[@"",@"",@""];
    
//    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    
//    imageView.image = [UIImage imageNamed:@"LaunchImage"];
//    [self.view addSubview:imageView];
//    [self performSelector:@selector(changeRootVC) withObject:nil afterDelay:2];
//    
//    [UIView animateWithDuration:2 animations:^{
//        imageView.alpha = 0.0;
//    }];
    [self changeRootVC];
    // Do any additional setup after loading the view.
}

-(void)changeRootVC
{
    UIApplication* application = [UIApplication sharedApplication];
    AppDelegate* delegate = application.delegate;
    
    NSArray* controllers = @[@"main",@"category",@"MerGoods",@"mine",@"more"];
//    NSArray* titles = @[@"首页",@"分类",@"商户",@"我的",@"更多"];
//    NSArray* images = @[@"shouye",@"fenlei",@"shanghu",@"wode",@"gengduo"];
//    NSArray* selecteds = @[@"shouyeed",@"fenleied",@"shanghued",@"wodeed",@"gengduoed"];
    NSMutableArray* navs = [[NSMutableArray alloc]init];
    for (int i = 0 ; i<controllers.count ;i++) {
        NSString* str = controllers[i];
        NSString* controllerName = [NSString stringWithFormat:@"%@ViewController",str];
        Class className = NSClassFromString(controllerName);
        UIViewController* VC = [[className alloc]init];
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:VC];
        
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"headbg"] forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        
        [nav.navigationBar setTitleTextAttributes:
                      @{NSForegroundColorAttributeName: [UIColor whiteColor],
                            NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
//        [nav.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"loding1"]];
//        [nav.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"loding1"]];
//        UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
//        [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn setImage:[UIImage imageNamed:@"head_finish"] forState:UIControlStateNormal];
//        UIBarButtonItem* im = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//        nav.navigationItem.backBarButtonItem = im;
        [navs addObject:nav];
    }
    
    
//    UITabBarController* bar = [[UITabBarController alloc]init];
    tabbarViewController* tabbar = [[tabbarViewController alloc]init];
    
    tabbar.viewControllers = navs;
    
    delegate.window.rootViewController = tabbar;
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
