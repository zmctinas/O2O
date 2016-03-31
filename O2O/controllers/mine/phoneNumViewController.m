//
//  phoneNumViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "phoneNumViewController.h"
#import "UIColor+hexColor.h"

@interface phoneNumViewController ()<UIScrollViewDelegate,HTTPRequestDataDelegate,UITextFieldDelegate>
{
    NSInteger remainTime;
    HTTPRequest* bgReq;
    NSUserDefaults* defaults;
    NSString* messages;
    NSString* onecode;
    NSString* twocode;
}

@property(strong,nonatomic)UILabel* label;

@property (weak, nonatomic) IBOutlet UILabel *line;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *oldMobileField;

@property (weak, nonatomic) IBOutlet UITextField *oldMobileTwo;

@property (weak, nonatomic) IBOutlet UITextField *codeOne;

@property (weak, nonatomic) IBOutlet UITextField *mobileField;

@property (weak, nonatomic) IBOutlet UITextField *codeTwo;

- (IBAction)nextBtn:(UIButton *)sender;

- (IBAction)yanzhengBtn:(UIButton *)sender;

- (IBAction)macodeBtn:(UIButton *)sender;

- (IBAction)querenBtn:(UIButton *)sender;



@end

@implementation phoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    
    [_oneBtn setTitleColor:[UIColor colorWithHexString:@"#FF447F"] forState:UIControlStateSelected];
    _oneBtn.selected = YES;
    [_twoBtn setTitleColor:[UIColor colorWithHexString:@"#FF447F"] forState:UIControlStateSelected];
    [_threeBtn setTitleColor:[UIColor colorWithHexString:@"#FF447F"] forState:UIControlStateSelected];
    
    bgReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    _bgone.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
    _bgone.layer.borderWidth = 1;
    _bgone.layer.cornerRadius = 3;
    _bgone.layer.masksToBounds = YES;
    _bgtwo.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
    _bgtwo.layer.borderWidth = 1;
    _bgtwo.layer.cornerRadius = 3;
    _bgtwo.layer.masksToBounds = YES;
    
    [_oldMobileField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_oldMobileTwo setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_mobileField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_codeOne setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    [_codeTwo setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    
    
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
    
    if (request == bgReq) {
        if (request.tag == 1) {
            if (message.integerValue == 1) {
                onecode = requestDic[@"code"];
            }else {
                messages = @"请输入正确的绑定手机号";
                [self showalert];
            }
        }else if (request.tag == 2)
        {
            if (message.integerValue == 1) {
                twocode = requestDic[@"code"];
            }else {
                messages = @"该手机号以绑定其他账号";
                [self showalert];
            }
        }
    }else
    {
        if ([message isEqualToString:@"1"]) {
            
            [defaults setObject:_mobileField.text forKey:@"mobile"];
            [defaults synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"绑定新手机号";
        _label.font = [UIFont boldSystemFontOfSize:17];
        
    }
    
    return _label;
}

#pragma mark - private

-(void)showalert
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messages delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}

-(void)changeBtn:(NSInteger)index
{
    UIButton* sender = (UIButton*)[self.view viewWithTag:10+index];
    sender.selected = YES;
    for (int i = 0 ; i<3; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:10+i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
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
    CGRect rect = _line.frame;
    rect.origin.x = index* SCREEN_WIDTH /3 ;
    _line.frame = rect;
    [UIView commitAnimations];
}



-(void)downTime:(UIButton*)sender
{
    
    sender.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if (remainTime < 0)
    {
        sender.enabled = !sender.enabled;
    }else
    {
        
        [sender setTitle:[NSString stringWithFormat:@"发送验证码(%ld)",(long)remainTime--] forState:UIControlStateDisabled];
        
        [self performSelector:@selector(downTime:) withObject:sender afterDelay:1];
        
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    [self moveLabel:index];
    [self changeBtn:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    [self moveLabel:index];
    [self changeBtn:index];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - xib

- (IBAction)nextBtn:(UIButton *)sender {
    
    NSString* regex = @"1[0-9]{10}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch =[pred evaluateWithObject:_oldMobileField.text];
    
    if (isMatch) {
        _oldMobileTwo.text = _oldMobileField.text;
        
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*1, 0) animated:YES];
    }else
    {
        messages = @"请输入正确手机号";
        [self showalert];
    }
    
    
    
    
}

- (IBAction)yanzhengBtn:(UIButton *)sender {
    
    if (_codeOne.text.floatValue == onecode.floatValue) {
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
    }else
    {
        messages = @"请输入正确的验证码";
        [self showalert];
    }
    
    
    
}

- (IBAction)macodeBtn:(UIButton *)sender {
    
    sender.enabled = !sender.enabled;
    remainTime = 59;
    [self performSelector:@selector(downTime:) withObject:sender afterDelay:1];
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (sender.tag == 50) {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_oldMobileField.text,@"mobile", nil];
        bgReq.tag = 1;
        [bgReq requestWitUrl:BDSJONE_IF andArgument:dic andType:WXHTTPRequestGet];
    }else if (sender.tag == 51)
    {
        NSString* regex = @"1[0-9]{10}";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        BOOL isMatch =[pred evaluateWithObject:_mobileField.text];
        
        if (isMatch) {
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_mobileField.text,@"mobile", nil];
            bgReq.tag = 2;
            [bgReq requestWitUrl:BDSJTWO_IF andArgument:dic andType:WXHTTPRequestGet];
        }else
        {
            messages = @"请输入正确的手机号";
            [self showalert];
        }
        
    }
    
}

- (IBAction)querenBtn:(UIButton *)sender {
    
    if (twocode.floatValue == _codeTwo.text.floatValue) {
        NSString* mobile = [[MyMD5 md5:_mobileField.text] lowercaseString];
        
        NSUserDefaults* defaules = [NSUserDefaults standardUserDefaults];
        NSString* uid = [defaules objectForKey:@"uid"];
        NSDictionary* dd = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",mobile,@"mobile",[[MyMD5 md5:[NSString stringWithFormat:@"%@%@",uid,mobile]] lowercaseString],@"sign", nil];
        HTTPRequest* request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
        [request requestWitUrl:EDITMOBILE_IF andArgument:dd andType:WXHTTPRequestPost];
    }else
    {
        messages = @"请输入正确的验证码";
        [self showalert];
    }
    
    
//    NSString* mobile = [[MyMD5 md5:_mobileField.text] lowercaseString];
//    
//    NSUserDefaults* defaules = [NSUserDefaults standardUserDefaults];
//    NSString* uid = [defaules objectForKey:@"uid"];
//    NSDictionary* dd = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",mobile,@"mobile",[[MyMD5 md5:[NSString stringWithFormat:@"%@%@",uid,mobile]] lowercaseString],@"sign", nil];
//    HTTPRequest* request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
//    [request requestWitUrl:EDITMOBILE_IF andArgument:dd andType:WXHTTPRequestPost];
}
@end
