//
//  feedBackViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/24.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "feedBackViewController.h"

@interface feedBackViewController ()<UITextViewDelegate,HTTPRequestDataDelegate,UIAlertViewDelegate>
{
    HTTPRequest* request;
    NSUserDefaults* defaults;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(strong,nonatomic)UILabel* label;

- (IBAction)tijiaoBtn:(UIButton *)sender;

@end

@implementation feedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(becomeFirst) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    _textView.layer.borderColor = [UIColor colorWithHexString:@"#C9C8C8"].CGColor;
    _textView.layer.borderWidth = 0.5;
    
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

-(void)becomeFirst
{
    if ([_textView.text isEqualToString:@"请输入您要反馈的信息"]) {
        _textView.text = @"";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    if (message.integerValue ==  1) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"反馈成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"意见反馈";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


#pragma mark - xib

- (IBAction)tijiaoBtn:(UIButton *)sender {
    
    if (_textView.text.length>0&&![_textView.text isEqualToString:@"请输入您要反馈的信息"]) {
        NSString* uid = [defaults objectForKey:@"uid"];
        NSString* userName = [defaults objectForKey:@"userName"];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",userName,@"name",_textView.text,@"content", nil];
        [request requestWitUrl:YIJIAN_IF andArgument:dic andType:WXHTTPRequestGet];
    }else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入反馈内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


@end
