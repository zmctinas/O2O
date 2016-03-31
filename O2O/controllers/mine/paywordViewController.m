//
//  paywordViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "paywordViewController.h"

@interface paywordViewController ()<UITextFieldDelegate,HTTPRequestDataDelegate>
{
    HTTPRequest* request ;
    NSString* payWord;
    NSUserDefaults* defaults;
    NSInteger level;
    NSString* messages;
    BOOL isSet;
    NSString* oldPayWord;
}



@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(strong,nonatomic)UILabel* label;

- (IBAction)goPayBtn:(UIButton *)sender;

- (IBAction)payword:(UIButton *)sender;

@end

@implementation paywordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_textField becomeFirstResponder];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.navigationItem.titleView = self.label;
    
    NSArray* arr = [self.view subviews];
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"payed"] forState:UIControlStateSelected];
        }
    }
    
    request = [[HTTPRequest alloc]init];
    request.delegate = self;
    
    NSString* payword = [defaults objectForKey:@"paypassword"];
    if (payword.length>0) {
        level = 0;
        
    }else
    {
        level = 1;
        isSet = YES;
    }
    [self initMessageLabel];
    // Do any additional setup after loading the view from its nib.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMessageLabel
{
    switch (level) {
        case 0:
            _tishiLabel.text = @"请输入原来的支付密码验证身份";//有支付密码
            break;
        case 1:
            _tishiLabel.text = @"请输入新的支付密码";//新支付密码
            break;
        case 2:
            _tishiLabel.text = @"请重新输入新的支付密码";//新支付密码2
            break;
            
        default:
            break;
    }
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    if ([message isEqualToString:@"1"]) {
        
        [defaults setObject:[MyMD5 md32:_textField.text].lowercaseString forKey:@"paypassword"];
        [defaults synchronize];
        [self clearBtn];
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
        _label.text = @"设置支付密码";
        _label.font = [UIFont boldSystemFontOfSize:17];
        
    }
    
    return _label;
}

#pragma mark - private

-(void)clearBtn
{
    
    payWord = _textField.text;
    
    NSArray* arr = [self.view subviews];
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
        }
    }

    [self textFieldShouldClear:_textField];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:range.location +10];
    
    [self payword:btn];
    if (range.location == 6) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    textField.text = @"";
    return YES;
    
}

-(void)showalert
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messages delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - xib

- (IBAction)goPayBtn:(UIButton *)sender {
    
    
    
    
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* uid = [defaults objectForKey:@"uid"];
    
    if (level == 0) {
        NSString* payword = [defaults objectForKey:@"paypassword"];
        if ([payword isEqualToString:[[MyMD5 md32:_textField.text] lowercaseString]]) {
            oldPayWord = [[MyMD5 md32:_textField.text] lowercaseString];
            level = 1;
            [self initMessageLabel];
            [self clearBtn];
        }else
        {
            messages = @"原支付密码错误";
            [self showalert];
            [self clearBtn];
        }
    }else if (level ==1)
    {
        level = 2;
        [self initMessageLabel];
        [self clearBtn];
    }else if (level == 2)
    {
        if (isSet) {
            NSString* payword = [[MyMD5 md32:_textField.text] lowercaseString];
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",payword,@"password",[[MyMD5 md32:[NSString stringWithFormat:@"%@%@",uid,payword]] lowercaseString],@"sign", nil];
            
            [request requestWitUrl:EDITPAY_IF andArgument:dic andType:WXHTTPRequestPost];
        }else
        {
            if ([payWord isEqualToString:_textField.text]) {
                NSString* newPayWord = [[MyMD5 md32:_textField.text] lowercaseString];
                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",oldPayWord,@"oldPassword",newPayWord,@"newPassword",[[MyMD5 md32:[NSString stringWithFormat:@"%@%@",uid,oldPayWord]] lowercaseString],@"sign", nil];
                [request requestWitUrl:XIUGAIPAY_IF andArgument:dic andType:WXHTTPRequestPost];
            }else
            {
                messages = @"两次输入不一致";
                [self showalert];
                [self clearBtn];
            }
        }
    }
    
    
    
}

- (IBAction)payword:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    
    
}
@end
