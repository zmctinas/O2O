//
//  loginViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "loginViewController.h"
#import "rePasswordViewController.h"
#import "registerViewController.h"
#import "UIColor+hexColor.h"

@interface loginViewController ()<HTTPRequestDataDelegate,UITextFieldDelegate>

@property(strong,nonatomic)UILabel* label;

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *passWord;

- (IBAction)loginBtn:(UIButton *)sender;



- (IBAction)registerBtn:(UIButton *)sender;

- (IBAction)rePassWord:(UIButton *)sender;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    _upView.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
    _upView.layer.borderWidth = 0.5;
    _downView.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
    _downView.layer.borderWidth = 0.5;
    
    [_userName setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_passWord setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    
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
    
    if (message.integerValue == 1) {

        NSUserDefaults* defaule = [NSUserDefaults standardUserDefaults];
        [defaule setObject:requestDic[@"money"] forKey:@"money"];
        [defaule setObject:requestDic[@"image"] forKey:@"headImage"];
        [defaule setObject:requestDic[@"mobile"] forKey:@"mobile"];
        [defaule setObject:requestDic[@"name"] forKey:@"userName"];
        [defaule setObject:requestDic[@"uid"] forKey:@"uid"];
        [defaule setObject:requestDic[@"integral"] forKey:@"integral"];
        [defaule setObject:_passWord.text forKey:@"passWord"];
        [defaule setBool:NO forKey:@"usePassword"];
        [defaule setObject:requestDic[@"paypassword"] forKey:@"paypassword"];
        [defaule setBool:YES forKey:@"isLogin"];
        [defaule synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (message.integerValue == 2)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户不存在" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }else if (message.integerValue == 3)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"密码错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"登录";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark - xib

- (IBAction)loginBtn:(UIButton *)sender {
    
    [_passWord resignFirstResponder];
    
    NSString* passwords = [[MyMD5 md5:_passWord.text] lowercaseString];
    
    HTTPRequest* request = [[HTTPRequest alloc]init];
    request.delegate = self;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_userName.text,@"mobile",passwords,@"passwords",[[MyMD5 md5:[NSString stringWithFormat:@"%@%@",_userName.text,passwords]] lowercaseString],@"sign", nil];
    [request requestWitUrl:LOGIN_IF andArgument:dic andType:WXHTTPRequestPost];
    
}

- (IBAction)registerBtn:(UIButton *)sender {
    
    registerViewController* root = [[registerViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
}

- (IBAction)rePassWord:(UIButton *)sender {
    
    rePasswordViewController* root = [[rePasswordViewController alloc]init];
    root.type = WXResetpassWord;
    [self.navigationController pushViewController:root animated:YES];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
