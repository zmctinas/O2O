//
//  rePasswordViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rePasswordViewController.h"
#import "UIColor+hexColor.h"

@interface rePasswordViewController ()<UITextFieldDelegate,HTTPRequestDataDelegate>
{
    NSString* messages;
    HTTPRequest* sendReq;
    HTTPRequest* pswrequest;
    NSString* code;
    NSTimer* timer;
    NSInteger num;
}

//nav
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

//first
@property (weak, nonatomic) IBOutlet UIView *querenView;
@property (weak, nonatomic) IBOutlet UITextField *querenField;
@property (weak, nonatomic) IBOutlet UIButton *querenBtn;

//second
@property (weak, nonatomic) IBOutlet UIView *firstyangzhengView;
@property (weak, nonatomic) IBOutlet UIView *secondyanzhengView;
@property (weak, nonatomic) IBOutlet UITextField *yanzhenmaField;
@property (weak, nonatomic) IBOutlet UIButton *yanzhengBtn;

//third
@property (weak, nonatomic) IBOutlet UIView *firstPassView;
@property (weak, nonatomic) IBOutlet UITextField *firstPassField;
@property (weak, nonatomic) IBOutlet UIView *secondPassView;
@property (weak, nonatomic) IBOutlet UITextField *secondPassField;
@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;

@property(strong,nonatomic)UILabel* label;

- (IBAction)quedingBtn:(UIButton *)sender;

- (IBAction)yanzhengBtn:(UIButton *)sender;

- (IBAction)sendBtn:(UIButton *)sender;

- (IBAction)querenBtn:(UIButton *)sender;

- (IBAction)navBtn:(UIButton *)sender;

@end

@implementation rePasswordViewController
{
    NSInteger _index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstyangzhengView.hidden = YES;
    _secondyanzhengView.hidden = YES;
    _yanzhengBtn.hidden = YES;
    _firstPassView.hidden = YES;
    _secondPassView.hidden = YES;
    _quedingBtn.hidden = YES;
    _tishiLabel.hidden = YES;
    
    self.navigationItem.titleView = self.label;
    
//    _madeView.layer.borderColor = [UIColor colorWithHexString:@"#E1E1E1"].CGColor;
//    _madeView.layer.borderWidth = 0.5;
    
    
    _secondyanzhengView.layer.borderColor = [UIColor colorWithHexString:@"#E1E1E1"].CGColor;
    _secondyanzhengView.layer.borderWidth = 0.5;
    _secondPassView.layer.borderColor = [UIColor colorWithHexString:@"#E1E1E1"].CGColor;
    _secondPassView.layer.borderWidth = 0.5;
    _firstPassView.layer.borderColor = [UIColor colorWithHexString:@"#E1E1E1"].CGColor;
    _firstPassView.layer.borderWidth = 0.5;

    
    [_firstBtn setTitleColor:[UIColor colorWithHexString:@"#FF1D74"] forState:UIControlStateSelected];
    [_secondBtn setTitleColor:[UIColor colorWithHexString:@"#FF1D74"] forState:UIControlStateSelected];
    [_thirdBtn setTitleColor:[UIColor colorWithHexString:@"#FF1D74"] forState:UIControlStateSelected];
    
    [_querenField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_yanzhenmaField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_firstPassField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_secondPassField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    
    _firstBtn.selected = YES;
    
    if (_type == WXResetmoblie) {
        
//        _querenField.placeholder = @"请输入用户名";
        
        _firstPassField.placeholder = @"请输入新的手机号";
        _secondPassField.placeholder = @"确认新手机号";
        
        
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(jishiTimer) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantFuture]];
    
    
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

-(void)moveLabel:(NSInteger)index
{
//    [UIView animateWithDuration:0.5 animations:^{
//        CGRect rect = _lineLabel.frame;
//        rect.origin.x = index* SCREEN_WIDTH /3 ;
//        _lineLabel.frame = rect;
//    }completion:^(BOOL finished) {
//        _mobileField.placeholder = _querenField.text;
//    }];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect rect = _lineLabel.frame;
    _lineLeft.constant = index* SCREEN_WIDTH /3 ;
//    rect.origin.x = index* SCREEN_WIDTH /3 ;
    _lineLabel.frame = rect;
    [UIView commitAnimations];
}

-(void)changeContent:(NSInteger)index
{
    
    NSArray* views = [self.view subviews];
    
    switch (index) {
        case 0:
            
            for (UIView* view in views) {
                if (view.tag == 100 || view.tag == 101) {
                    view.hidden = NO;
                }else if (view.tag >= 100)
                {
                    view.hidden = YES;
                }
            }
            
            break;
        case 1:
            for (UIView* view in views) {
                if (view.tag == 100 || view.tag == 102 || view.tag == 103 || view.tag == 104) {
                    view.hidden = NO;
                }else if (view.tag >= 100)
                {
                    view.hidden = YES;
                }
            }
            
            break;
        case 2:
            for (UIView* view in views) {
                if (view.tag == 105 || view.tag == 106 || view.tag == 107 ) {
                    view.hidden = NO;
                }else if (view.tag == 108)
                {
                    if (_type == WXResetmoblie) {
                        view.hidden = YES;
                    }else
                    {
                        view.hidden = NO;
                    }
                }
                else if (view.tag >= 100)
                {
                    view.hidden = YES;
                }
            }
            
            break;
        default:
            break;
    }
}

-(void)jishiTimer
{
    num--;
    if (num<1) {
        _sendBtn.enabled = YES;
        [_sendBtn setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateNormal];
        return;
    }else
    {
        _sendBtn.enabled = NO;
        [_sendBtn setTitle:[NSString stringWithFormat:@"发送验证码(%ld)",num] forState:UIControlStateNormal];
        [self performSelector:@selector(jishiTimer) withObject:nil afterDelay:1.0f];
        return;
    }
    
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    NSLog(@"%@",requestDic);
    NSString* message = requestDic[@"message"];
    if (request == pswrequest) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if (message.integerValue == 1) {
            if (_type == WXResetmoblie) {
                [defaults setObject:_querenField.text forKey:@"mobile"];
                
            }else if (_type == WXResetpassWord)
            {
                [defaults setObject:_firstPassField.text forKey:@"passWord"];
            }
            [defaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            messages = @"用户不存在";
            [self showalert];
        }
        
        
    }else if (request == sendReq)
    {
        if (message.integerValue == 1) {
            code = requestDic[@"code"];
            num = 60;
            [_sendBtn setTitle:[NSString stringWithFormat:@"发送验证码(%ld)",num] forState:UIControlStateNormal];
            _sendBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            _sendBtn.enabled = NO;

            [self jishiTimer];
        }else
        {
            messages = @"获取验证码失败";
            [self showalert];
            [self jishiTimer];
        }
    }
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"找回密码";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

-(void)showalert
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messages delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}


#pragma mark - xib


- (IBAction)quedingBtn:(UIButton *)sender {
    
    NSString* regex = @"^\\w{4,16}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch =[pred evaluateWithObject:_firstPassField.text];
    
    if ([_firstPassField.text isEqualToString:_secondPassField.text]) {
        if (isMatch) {
            pswrequest = [[HTTPRequest alloc]init];
            pswrequest.delegate = self;
            NSDictionary* dic = nil;
            NSString* mobile = [[MyMD5 md5:_querenField.text] lowercaseString];
            
//            NSUserDefaults* defaules = [NSUserDefaults standardUserDefaults];
//            NSString* uid = [defaules objectForKey:@"uid"];
            
            if (_type == WXResetmoblie) {
                
            }else if (_type == WXResetpassWord)
            {
                NSString* password = [[MyMD5 md5:_firstPassField.text] lowercaseString];
                
                NSDictionary* dd = [NSDictionary dictionaryWithObjectsAndKeys:_querenField.text,@"mobile",password,@"password",[[MyMD5 md5:[NSString stringWithFormat:@"%@%@",mobile,password]] lowercaseString],@"sign", nil];
                dic = dd;
                [pswrequest requestWitUrl:RESETPASS_IF andArgument:dic andType:WXHTTPRequestPost];
            }
        }else
        {
            messages = @"密码不符合要求";
            [self showalert];
        }
    }else
    {
        messages = @"两次密码输入不一致";
        [self showalert];
    }
    
}

- (IBAction)yanzhengBtn:(UIButton *)sender {
    
    if (_yanzhenmaField.text.floatValue == code.integerValue) {
        [self moveLabel:2];
        [self changeContent:2];
        [self changeBtn:2];
    }else
    {
        messages = @"请输入正确的验证码";
        [self showalert];
    }
    
}

- (IBAction)sendBtn:(UIButton *)sender {
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_querenField.text,@"mobile", nil];
    sendReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    [sendReq requestWitUrl:FINDMOBILE_IF andArgument:dic andType:WXHTTPRequestGet];
    
}

- (IBAction)querenBtn:(UIButton *)sender {
    
    NSString* regex = @"1[0-9]{10}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch =[pred evaluateWithObject:_querenField.text];
    if (isMatch) {
        [self moveLabel:1];
        
        [self changeContent:1];
        [self changeBtn:1];
        _woquimageView.image = [UIImage imageNamed:@"input"];
    }else
    {
        messages = @"非法手机号";
        [self showalert];
    }
    
    
}

-(void)changeBtn:(NSInteger)index
{
    UIButton* sender = (UIButton*)[self.view viewWithTag:10+index];
    sender.selected = YES;
    for (int i = 0; i<3; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:10+i];
        if (btn.tag!= sender.tag) {
            btn.selected = NO;
        }
    }
}

- (IBAction)navBtn:(UIButton *)sender {
    
    _index = sender.tag;
    
}
@end
