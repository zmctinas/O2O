//
//  passWordViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "passWordViewController.h"

@interface passWordViewController ()<HTTPRequestDataDelegate,UITextFieldDelegate>
{
    UIAlertView* alert;
}

@property (weak, nonatomic) IBOutlet UIView *thirdView;



@property (weak, nonatomic) IBOutlet UITextField *oldPassword;

@property (weak, nonatomic) IBOutlet UITextField *One;
//
@property (weak, nonatomic) IBOutlet UITextField *Two;


- (IBAction)quedingBtn:(UIButton *)sender;

@property(strong,nonatomic)UILabel* label;

@end

@implementation passWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    [_oldPassword setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_One setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_Two setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    
    _thirdView.layer.borderColor = [UIColor colorWithHexString:@"#D6D6D6"].CGColor;
    _thirdView.layer.borderWidth = 1;
    _thirdView.layer.cornerRadius = 3;
    _thirdView.layer.masksToBounds = YES;
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
    NSLog(@"%@",requestDic);
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* message = [NSString stringWithFormat:@"%@",requestDic[@"message"]];
    
    if ([message isEqualToString:@"1"]) {
        [defaults setObject:_Two.text forKey:@"passWord"];
        [defaults synchronize];
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
        _label.text = @"修改密码";
        _label.font = [UIFont boldSystemFontOfSize:17];
        
    }
    
    return _label;
}

#pragma mark - xib

- (IBAction)quedingBtn:(UIButton *)sender {
    
    HTTPRequest* request = [[HTTPRequest alloc]init];
    request.delegate = self;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* uid = [defaults objectForKey:@"uid"];
    NSString* password = [defaults objectForKey:@"passWord"];
    
    
    if (![_oldPassword.text isEqualToString:password]) {
        alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"原密码输入错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString* oldPassword = [[MyMD5 md5:_oldPassword.text] lowercaseString];
    NSString* newPassword = [[MyMD5 md5:_One.text] lowercaseString];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",oldPassword,@"oldPassword",newPassword,@"newPassword",[[MyMD5 md5:[NSString stringWithFormat:@"%@%@",uid,oldPassword]] lowercaseString],@"sign", nil];
    
    [request requestWitUrl:EDITPASS_IF andArgument:dic andType:WXHTTPRequestPost];
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* regex = @"[0-9]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch =[pred evaluateWithObject:string];
    if (isMatch) {
        return YES;
    }
    return NO;
    
}

@end
