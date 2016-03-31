//
//  registerViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/14.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "registerViewController.h"
#import "UIColor+hexColor.h"
#import "xieyiViewController.h"

@interface registerViewController ()<UITextFieldDelegate,HTTPRequestDataDelegate,UIAlertViewDelegate,HTTPRequestDataDelegate>
{
    HTTPRequest* mobileReq;
    HTTPRequest* zhucerequest;
    NSString* code;
    NSString* message;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UITextField *secondField;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *querenBtn;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UIButton *zhuceBtn;

@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;

@property (weak, nonatomic) IBOutlet UITextField *mobileField;

@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaField;

@property (weak, nonatomic) IBOutlet UITextField *firstField;

@property (weak, nonatomic) IBOutlet UIView *mobileView;

@property (weak, nonatomic) IBOutlet UIView *yanzhengView;

@property (weak, nonatomic) IBOutlet UIView *passView;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property(strong,nonatomic)UILabel* label;

- (IBAction)checkBtn:(UIButton *)sender;

- (IBAction)tijiaoBtn:(UIButton *)sender;

- (IBAction)zhuceBtn:(UIButton *)sender;

- (IBAction)navBtn:(UIButton *)sender;
- (IBAction)querenBtn:(UIButton *)sender;

@end

@implementation registerViewController
{
    NSInteger _index;
    NSString* mobile;
    NSString* YZM;
    NSString* passWord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mobileReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    self.secondView.hidden = YES;
    self.tijiaoBtn.hidden = YES;
    self.zhuceBtn.hidden = YES;
//    self.querenBtn.enabled = NO;
//    self.tijiaoBtn.enabled = NO;
//    self.zhuceBtn.enabled = NO;
    self.yanzhengView.hidden = YES;
    self.passView.hidden = YES;
    [self.checkBtn setImage:[UIImage imageNamed:@"xieyied"] forState:UIControlStateSelected];
    [self.querenBtn setBackgroundImage:[UIImage imageNamed:@"regbtn"] forState:UIControlStateDisabled];
    
    [self.querenBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn"] forState:UIControlStateNormal];
    
    self.navigationItem.titleView = self.label;
    
    [_oneBtn setTitleColor:[UIColor colorWithHexString:@"#FF4C82"] forState:UIControlStateSelected];
    _oneBtn.selected = YES;
    [_twoBtn setTitleColor:[UIColor colorWithHexString:@"#FF4C82"] forState:UIControlStateSelected];
    [_thirdBtn setTitleColor:[UIColor colorWithHexString:@"#FF4C82"] forState:UIControlStateSelected];
    
    [_firstField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_secondField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_mobileField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_yanzhengmaField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    NSLog(@"%@",requestDic);
    if (request == zhucerequest) {
        NSString* messages = requestDic[@"message"];
        NSString* tishi = nil;
        if ([messages isEqualToString:@"1"]) {
            tishi = @"注册成功";
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            tishi = @"用户已存在";
        }
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tishi delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] ;
        [alert show];
    }else if (request == mobileReq)
    {
        NSString* messages = requestDic[@"message"];
        
        if ([messages isEqualToString:@"1"]) {
            [self moveLabel:1];
            [self changeContent:1];
            [self changeBtn:1];
            mobile = _mobileField.text;
            
            code = requestDic[@"code"];
            
        }else
        {
            message = @"该号码已经注册";
            [self showalert];
        }
    }
    
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

-(void)initscrollView
{
    
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

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"注册";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

-(void)moveLabel:(NSInteger)index
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _lineLabel.frame;
        _lineLeft.constant =index* SCREEN_WIDTH /3 ;
//        rect.origin.x = index* SCREEN_WIDTH /3 ;
//        _lineLabel.frame = rect;
    }completion:^(BOOL finished) {
        
    }];
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

-(void)changeContent:(NSInteger)index
{
    switch (index) {
        case 0:

            self.secondView.hidden = YES;
            self.thirdView.hidden = NO;
            self.querenBtn.hidden = NO;
            self.zhuceBtn.hidden = YES;
            self.tijiaoBtn.hidden = YES;
            self.mobileView.hidden = NO;
            self.yanzhengView.hidden = YES;
            self.passView.hidden = YES;
            
            break;
        case 1:

            self.thirdView.hidden = YES;
            self.secondView.hidden = YES;
            self.querenBtn.hidden = YES;
            self.tijiaoBtn.hidden = NO;
            self.zhuceBtn.hidden = YES;
            self.mobileView.hidden = YES;
            self.yanzhengView.hidden = NO;
            self.passView.hidden = YES;
            
            break;
        case 2:

            self.secondView.hidden = NO;
            self.querenBtn.hidden = YES;
            self.zhuceBtn.hidden = NO;
            self.tijiaoBtn.hidden = YES;
            self.thirdView.hidden = YES;
            self.mobileView.hidden = YES;
            self.yanzhengView.hidden = YES;
            self.passView.hidden = NO;
            
            break;
        default:
            break;
    }
}

- (IBAction)checkBtn:(UIButton *)sender {
    
    sender.selected = ! sender.selected;
    
}

- (IBAction)tijiaoBtn:(UIButton *)sender {
    
    
    if (_yanzhengmaField.text.integerValue == code.integerValue) {
        [self moveLabel:2];
        [self changeContent:2];
        [self changeBtn:2];
    }else
        
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

- (IBAction)zhuceBtn:(UIButton *)sender {
    
    NSString* regex = @"^\\w{6,16}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch =[pred evaluateWithObject:_firstField.text];
    
    if ([_firstField.text isEqualToString:_secondField.text]) {
        if (isMatch) {
            zhucerequest = [[HTTPRequest alloc]init];
            zhucerequest.delegate = self;
            
            NSString* password = [[MyMD5 md5:_firstField.text] lowercaseString];
            NSLog(@"%@",_firstField.text);
            NSLog(@"%@",_mobileField.text);
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[_mobileField.text substringToIndex:11],@"mobile",password,@"password",[[MyMD5 md5:[NSString stringWithFormat:@"%@%@",[_mobileField.text substringToIndex:11],password]] lowercaseString],@"sign", nil];
            
            [zhucerequest requestWitUrl:REGISTER_IF andArgument:dic andType:WXHTTPRequestPost];
        }else
        {
            message = @"请输入6~16个字符的密码";
            [self showalert];
        }
    }else
    {
        message = @"两次输入不正确";
        [self showalert];
    }
    
    
    
    
    
}

- (IBAction)navBtn:(UIButton *)sender {
    
    sender.selected = YES;
    
    for (int i = 0; i<3; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:10+i];
        if (btn.tag!= sender.tag) {
            btn.selected = NO;
        }
    }
    
    _index = sender.tag - 10;
    
    [self moveLabel:_index];
    
    [self changeContent:_index];
    
}

- (IBAction)querenBtn:(UIButton *)sender {
    
    NSString* regex = @"1[0-9]{10}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch =[pred evaluateWithObject:_mobileField.text];
    if (isMatch) {
        if (_checkBtn.selected) {
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_mobileField.text,@"mobile", nil];
            [mobileReq requestWitUrl:MOBILE_IF andArgument:dic andType:WXHTTPRequestGet];
        }else
        {
            message = @"请点击用户协议";
            [self showalert];
        }
    }else
    {
        message = @"非法手机号";
        [self showalert];
    }
    
}

-(void)showalert
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    if (textField != _firstField && textField!=_secondField) {
//        return YES;
//    }else if (range.location > 9) {
//        return NO;
//    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _mobileField) {
        if (_index == 0) {
            _querenBtn.enabled = YES;
            
        }else if(_index == 1 )
        {
            _tijiaoBtn.enabled = YES;
        }
    }
    
}

- (IBAction)xieyiBtn:(UIButton *)sender {
    
    xieyiViewController* root = [[xieyiViewController alloc]init];
    
    [self.navigationController pushViewController:root animated:YES];
    
}
@end
