//
//  userNameViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "userNameViewController.h"

@interface userNameViewController ()<HTTPRequestDataDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    HTTPRequest* _request;
    NSUserDefaults* defaults;
}

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property(strong,nonatomic)UILabel* label;

@property (weak, nonatomic) IBOutlet UIButton *querenBtn;

- (IBAction)querenBtn:(UIButton *)sender;

@end

@implementation userNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    _request = [[HTTPRequest alloc]init];
    _request.delegate = self;
    
    [_userName setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    
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

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    
    NSString* message = requestDic[@"message"];
    
    if ([message isEqualToString:@"1"]) {
        [defaults setObject:_userName.text forKey:@"userName"];
        [defaults synchronize];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        alert.tag = 10;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView.tag == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"修改用户名";
        _label.font = [UIFont boldSystemFontOfSize:17];
        
    }
    
    return _label;
}

- (IBAction)querenBtn:(UIButton *)sender {
    
    NSString* regex = @"^\\w{4,6}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch =[pred evaluateWithObject:_userName.text];
    
    
    if (isMatch) {
        
        
        NSString* uid = [defaults objectForKey:@"uid"];
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_userName.text,@"username", nil];
        
        [_request requestWitUrl:EDITNAME_IF andArgument:dic andType:WXHTTPRequestPost];
    }else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不符合要求" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
