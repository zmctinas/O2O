//
//  rechargeViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rechargeViewController.h"
#import "WXPayStart.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
#import "AppDelegate.h"
#import "UIColor+hexColor.h"

@interface rechargeViewController ()<HTTPRequestDataDelegate,UITextFieldDelegate>
{
    HTTPRequest* ordernumReq;
    UIButton* selectBtn;
    NSUserDefaults* defaults;
    WXPayStart* weixinZhifu;
}

@property(strong,nonatomic)UILabel* label;

@end

@implementation rechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    [self initBtn];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    ordernumReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    [ordernumReq requestWitUrl:ORDERNUM andArgument:nil andType:WXHTTPRequestGet];
    
    [self initBalance];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:@"zhifubao" object:nil];
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
    [ordernumReq requestWitUrl:ORDERNUM andArgument:nil andType:WXHTTPRequestGet];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    _ordernum = requestDic[@"odernum"];
    NSLog(@"%@",_ordernum);
}

#pragma mark - private

-(void)paySuccess
{
    float money = [[defaults objectForKey:@"money"] floatValue];
    money = money + _textField.text.floatValue;
    [defaults setObject:[NSString stringWithFormat:@"%0.2f",money] forKey:@"money"];
    [defaults synchronize];
    [self initBalance];
}

-(void)initBalance
{
    NSString* money = [defaults objectForKey:@"money"];
    _balance.text = [NSString stringWithFormat:@"￥%@",money];
    _textField.layer.borderColor = [UIColor colorWithHexString:@"#D3D3D3"].CGColor;
    _textField.layer.borderWidth = 0.5;
}

-(void)initBtn
{
    UIButton* btn = (UIButton*)[self.view viewWithTag:10];
    [btn setImage:[UIImage imageNamed:@"alipaycheck"] forState:UIControlStateSelected];
    UIButton* btn2 = (UIButton*)[self.view viewWithTag:11];
    [btn2 setImage:[UIImage imageNamed:@"wechatcheck"] forState:UIControlStateSelected];
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"在线充值";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


- (IBAction)payStyleBtn:(UIButton *)sender {
    
    sender.selected = YES;
    selectBtn = sender;
    for (int i = 0; i<2; i++) {
        UIButton* btn = (UIButton*)[_scrollView viewWithTag:10+i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    
}

- (IBAction)goBuy:(UIButton *)sender {
    
    if (selectBtn == nil) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择充值方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    UIApplication* app = [UIApplication sharedApplication];
    AppDelegate* delegate = app.delegate;
    delegate.delegate = self;
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (selectBtn.tag == 10) {
        NSString* uid = [defaults objectForKey:@"uid"];
        NSString* privatekey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAK2ezWt4x+fNpQBT+gYeGT5rPewc05G1XGvUaRWk5GeDsCUzo8VXkb0B0twPuuYb2b9a0RSMPK4rBo9Zr6Cy5ZJSBnDhyNjnvhbQRHVxwbqsG2C/VEZuDKF4u9mq0AwK8xcD/CAVh6c8fpyDHGpK2cW+UX+6D00721EL0Vuz55VNAgMBAAECgYBovGaxUZBOjujd1Mr8S8XwuKMHP7CFssGJLv8hlnJO28sz9f3yu0vomCQKqtaVn/FwlSmR2rN0YfI4IeNn7uO7rSquedKFzXnnLBkw3vhSGFaBjoE94vGh2xt0bFjrWCPk0Wol350zSDEtce6FRVArWVZEjCCiWhAqMNL5rzw9hQJBAODQOkDarGGqhysBvCDPTzEQ6dK4omUpShKcEdszj5Z9TcYcmyUtWr7V9bzBDtgTWunffMzXr2a3S7+Egahyy2cCQQDFtI+vsao3Hmp740P9WZO4XuwYItXi/CLzbPMMNGXqAr17CEXWv79itlK39MFTLenvrSafTJFCckx0dXLLjV0rAkEAr8fAtLMGtDrtA2CQ46qVBg1udngtaiHVrCViBN4U+JszM6NsX65N1Qdg5FyjqanAnTtEzroaiJrrXG1UIAzaIwJBAJX0Ofec3eoom8OTwQHsa2qwNIqqAWjErQ3NWRusspAnu+gRgkc78MHCYEM+1VNtw74SqvSwcozffLXoT0Ws1zkCQQCiMAmh2L8wyRQanRn5KlISrrvXxiA568+sIwehMWsI4+61bavU14lB/es9SpVYnEsHFcvHCUUl26vcWq8DJdgd";
        Order* order = [[Order alloc]init];
        order.partner = @"2088911324345035";
        order.seller = @"yxktshangmao@sina.com";
        order.tradeNO = _ordernum; //订单ID(由商家□自□行制定)
        order.productName = @"kaitong"; //商品标题
        order.productDescription = uid; //商品描述
        NSLog(@"%0.2f",_textField.text.floatValue);
        order.amount = [NSString stringWithFormat:@"%.2f",_textField.text.floatValue]; //商品价格
        
        order.notifyURL = @"http://115.28.133.70/interface/alipay/notify_url.php"; //回调URL
        
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showUrl = @"m.alipay.com";
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"kaitong";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        NSLog(@"orderSpec = %@",orderSpec);
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privatekey);
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            
            
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    [self paySuccess];
                }
            }];
            
//            [AlipaySDK defaultService]processOrderWithPaymentResult:[NSURL URLWithString:<#(NSString *)#>] standbyCallback:^(NSDictionary *resultDic) {
//                
//            }
            
        }
    }else
    {
        NSLog(@"%@",uid);
        weixinZhifu=[WXPayStart share];
        [defaults setObject:_ordernum forKey:@"order_num"];
        [defaults setObject:_textField.text forKey:@"order_money"];
        [defaults setObject:@"" forKey:@"zhpay"];
        [defaults synchronize];
        [weixinZhifu sendPay:[NSString stringWithFormat:@"%@_%@",_ordernum,uid] amount:[NSString stringWithFormat:@"%ld",(long)(_textField.text.floatValue*100)]
                   orderName:@"凯通"];
        
        
    }
    
}
- (IBAction)textField:(UITextField *)sender {
}
@end
