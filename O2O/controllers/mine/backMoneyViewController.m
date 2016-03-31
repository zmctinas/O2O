//
//  backMoneyViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/7/3.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "backMoneyViewController.h"
#import "UIColor+hexColor.h"

@interface backMoneyViewController ()<UITextViewDelegate,HTTPRequestDataDelegate>
{
    HTTPRequest* backReq;
    NSUserDefaults* defaults;
}

@property(strong,nonatomic)UILabel* label;

@end

@implementation backMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    _hang1View.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    _hang1View.layer.borderWidth = 0.3;
    _hang1View.layer.cornerRadius = 2;
    _hang2View.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    _hang2View.layer.borderWidth = 0.3;
    _hang2View.layer.cornerRadius = 2;
    _textView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    _textView.layer.borderWidth = 0.3;
    _textView.layer.cornerRadius = 2;
    
    _moneyLabel.text = _totalMoney;
    
    self.navigationItem.titleView = self.label;
    
    backReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"我要退款";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
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
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请成功" delegate:self  cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [WXalertView alertWithMessage:@"退款失败" andDelegate:self];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_textView.text isEqualToString:@"退款原因（200字以内）"]) {
        _textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_textView.text isEqualToString:@""]) {
        _textView.text = @"退款原因（200字以内）";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (IBAction)tijiaoBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_orderid,@"ordernum",uid,@"uid", nil];
    [backReq requestWitUrl:ORDERBACK_IF andArgument:dic andType:WXHTTPRequestGet];
    
}
@end
