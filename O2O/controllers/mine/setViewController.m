//
//  setViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "setViewController.h"
#import "goodsViewController.h"
#import "UIColor+hexColor.h"
#import "userNameViewController.h"
#import "passWordViewController.h"
#import "rePasswordViewController.h"
#import "paywordViewController.h"
#import "phoneNumViewController.h"
#import "servicecenterViewController.h"
#import "formeViewController.h"

@interface setViewController ()
{
    NSUserDefaults* defaults;
}

@property (weak, nonatomic) IBOutlet UILabel *userName;

- (IBAction)setBtn:(UIButton *)sender;



@end

@implementation setViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    label.text = @"设置";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = label;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"isLogin"]) {
        _userName.text = [defaults objectForKey:@"userName"];
    }else
    {
        _userName.text = @"昵称";
    }
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setBtn:(UIButton *)sender {
    
    NSInteger index = sender.tag;
    
    userNameViewController* userName = [[userNameViewController alloc]init];
    goodsViewController* goods = [[goodsViewController alloc]init];
    passWordViewController* password = [[passWordViewController alloc]init];
//    rePasswordViewController* repass = [[rePasswordViewController alloc]init];
    paywordViewController* payWord = [[paywordViewController alloc]init];
    phoneNumViewController* phone = [[phoneNumViewController alloc]init];
    servicecenterViewController* service = [[servicecenterViewController alloc]init];
    formeViewController* forme = [[formeViewController alloc]init];
    
    switch (index) {
        case 0:
            [self.navigationController pushViewController:userName animated:YES];
            break;
        case 1:
            
            [self.navigationController pushViewController:goods animated:YES];
            
            break;
        case 2:
            
            [self.navigationController pushViewController:phone animated:YES];
            
            break;
        case 3:
            
            [self.navigationController pushViewController:password animated:YES];
            
            break;
        case 4:
            
            [self.navigationController pushViewController:payWord animated:YES];
            
            break;
        case 5:
            [self.navigationController pushViewController:service animated:YES];
            
            break;
        case 6:
            [self.navigationController pushViewController:forme animated:YES];
            
            break;
        
            
        default:
            break;
    }
    
}
- (IBAction)signoutBtn:(UIButton *)sender {
    
    [defaults removeObjectForKey:@"uid"];
    [defaults removeObjectForKey:@"userName"];
    [defaults removeObjectForKey:@"passWord"];
    [defaults removeObjectForKey:@"mobile"];
    [defaults removeObjectForKey:@"headImage"];
    [defaults removeObjectForKey:@"balance"];
    [defaults removeObjectForKey:@"isLogin"];
    [defaults removeObjectForKey:@"paypassword"];
    [defaults removeObjectForKey:@"usePassword"];
    [defaults removeObjectForKey:@""];
    [defaults removeObjectForKey:@""];
    [defaults removeObjectForKey:@""];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
