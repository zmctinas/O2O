//
//  gopayViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "gopayViewController.h"
#import "WXPayStart.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
#import "UIColor+hexColor.h"
#import "HTTPRequest.h"
#import "AppDelegate.h"
#import "MyMD5.h"


@interface gopayViewController ()<UITextFieldDelegate,HTTPRequestDataDelegate,UIAlertViewDelegate>
{
    NSInteger selected;
    WXPayStart* weixinZhifu;
    NSInteger payStyle;
    BOOL usecar;
    NSUserDefaults* defaults;
    NSString* huiyuanpayMoney;
    NSString* shengyuMoney;
    HTTPRequest* huiyuanPay;
    HTTPRequest* payReq;
    NSString* payfreight;
}
@property (weak, nonatomic) IBOutlet UIButton *payfreightBtn;

@property (weak, nonatomic) IBOutlet UIView *payFreight;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalmoneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *mvpBtn;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UITextField *passField;

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBnt;

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@property(strong,nonatomic)UILabel* label;

- (IBAction)mvpBtn:(UIButton *)sender;

- (IBAction)payBtn:(UIButton *)sender;

- (IBAction)zhifu:(UIButton *)sender;


@end

@implementation gopayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mvpBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [self.wechatBtn setImage:[UIImage imageNamed:@"radioed"] forState:UIControlStateSelected];
    [self.payBnt setImage:[UIImage imageNamed:@"radioed"] forState:UIControlStateSelected];
    self.passField.hidden = YES;
    
    self.navigationItem.titleView = self.label;
    
    _numberLabel.text = _ordernum;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    _balanceLabel.text = [NSString stringWithFormat:@"%@元",_yueMoney];
    _balanceLabel.adjustsFontSizeToFitWidth = YES;
    
    _totalmoneyLabel.text = [NSString stringWithFormat:@"%@元",_totalPrice];
    shengyuMoney = _totalPrice;
    
    _sumLabel.text = [NSString stringWithFormat:@"%@元",_totalPrice];
    
    _passField.layer.borderColor = [UIColor colorWithHexString:@"#E8E8E8"].CGColor;
    _passField.layer.borderWidth = 0.5;
    
    payReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    huiyuanPay = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifuchonggong:) name:@"zhifuchenggong" object:nil];
    
    if (![_payfreight isEqualToString:@"0"]) {
        self.payFreight.hidden = YES;
        self.payfreightBtn.hidden = YES;
    }
    
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    if (request == huiyuanPay) {
        if ([message isEqualToString:@"1"]&& [shengyuMoney isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggong" object:self userInfo:nil];
        }else if ([message isEqualToString:@"1"]&&payStyle!=0) {
            [self payMoney];
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }
    }else if (request == payReq)
    {
        if ([message isEqualToString:@"1"]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            UIApplication* app = [UIApplication sharedApplication];
            AppDelegate* delegate = app.delegate;
            UIViewController* root = (UIViewController*)delegate.delegate;
            [self.navigationController popToViewController:root animated:YES];
        }
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertViewCancel:(UIAlertView *)alertView
{
    
}

#pragma mark - private

-(void)payMoney
{
    
    if (payStyle == 10) {
        weixinZhifu=[WXPayStart share];
        [defaults setObject:_ordernum forKey:@"order_num"];
        [defaults setObject:shengyuMoney forKey:@"order_money"];
        [defaults setObject:huiyuanpayMoney forKey:@"zhpay"];
        [defaults synchronize];
        NSString* uid = [defaults objectForKey:@"uid"];
        
        NSString* totalMoney = [NSString stringWithFormat:@"%ld",[[NSString stringWithFormat:@"%.2f",shengyuMoney.floatValue*100] integerValue]];
        [weixinZhifu sendPay:[NSString stringWithFormat:@"%@_%@",_ordernum,uid] amount:totalMoney orderName:@"凯通"];
        
    }else
    {
        NSString* uid = [defaults objectForKey:@"uid"];
        NSString* privatekey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAK2ezWt4x+fNpQBT+gYeGT5rPewc05G1XGvUaRWk5GeDsCUzo8VXkb0B0twPuuYb2b9a0RSMPK4rBo9Zr6Cy5ZJSBnDhyNjnvhbQRHVxwbqsG2C/VEZuDKF4u9mq0AwK8xcD/CAVh6c8fpyDHGpK2cW+UX+6D00721EL0Vuz55VNAgMBAAECgYBovGaxUZBOjujd1Mr8S8XwuKMHP7CFssGJLv8hlnJO28sz9f3yu0vomCQKqtaVn/FwlSmR2rN0YfI4IeNn7uO7rSquedKFzXnnLBkw3vhSGFaBjoE94vGh2xt0bFjrWCPk0Wol350zSDEtce6FRVArWVZEjCCiWhAqMNL5rzw9hQJBAODQOkDarGGqhysBvCDPTzEQ6dK4omUpShKcEdszj5Z9TcYcmyUtWr7V9bzBDtgTWunffMzXr2a3S7+Egahyy2cCQQDFtI+vsao3Hmp740P9WZO4XuwYItXi/CLzbPMMNGXqAr17CEXWv79itlK39MFTLenvrSafTJFCckx0dXLLjV0rAkEAr8fAtLMGtDrtA2CQ46qVBg1udngtaiHVrCViBN4U+JszM6NsX65N1Qdg5FyjqanAnTtEzroaiJrrXG1UIAzaIwJBAJX0Ofec3eoom8OTwQHsa2qwNIqqAWjErQ3NWRusspAnu+gRgkc78MHCYEM+1VNtw74SqvSwcozffLXoT0Ws1zkCQQCiMAmh2L8wyRQanRn5KlISrrvXxiA568+sIwehMWsI4+61bavU14lB/es9SpVYnEsHFcvHCUUl26vcWq8DJdgd";
        Order* order = [[Order alloc]init];
        order.partner = @"2088911324345035";
        order.seller = @"yxktshangmao@sina.com";
        order.tradeNO = _ordernum; //订单ID(由商家□自□行制定)
        order.productName = @"kaitong"; //商品标题
        order.productDescription = uid; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",shengyuMoney.floatValue]; //商品价格
        
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
        
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privatekey);
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                if ([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggong" object:self userInfo:nil];
                }
            }];
            
        }
    }

}

-(void)zhifuchonggong:(NSNotification*)userinfo
{
    
    NSString* money = [defaults objectForKey:@"money"];
    float huiyuanMoney = money.floatValue;
    
    [defaults setObject:[NSString stringWithFormat:@"%.2f",huiyuanMoney - huiyuanpayMoney.floatValue] forKey:@"money"];
    
    [defaults synchronize];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
    UIApplication* app = [UIApplication sharedApplication];
    AppDelegate* delegate = app.delegate;
    UIViewController* root = (UIViewController*)delegate.delegate;
    if (root == nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popToViewController:root animated:YES];
    }
    
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"确认支付";
        _label.font = [UIFont boldSystemFontOfSize:17];
        
    }
    
    return _label;
}

- (IBAction)mvpBtn:(UIButton *)sender {
    
    NSString* paypassword = [defaults objectForKey:@"paypassword"];
    if (paypassword == nil) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"还未设置支付密码" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    sender.selected = !sender.selected;
    usecar = sender.selected;
    if (sender.selected) {
        
        if (_totalPrice.floatValue > _yueMoney.floatValue) {
            sender.selected = NO;
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"余额不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
//            shengyuMoney = [NSString stringWithFormat:@"%0.2f",_totalPrice.floatValue - _yueMoney.floatValue];
//            _sumLabel.text = [NSString stringWithFormat:@"%@元",shengyuMoney];
//            huiyuanpayMoney = _yueMoney;
        }else
        {
            shengyuMoney = @"0";
            huiyuanpayMoney = [NSString stringWithFormat:@"%0.2f",[_totalPrice floatValue]];
            _sumLabel.text = @"0元";
        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"usePassword"]) {
            self.passField.hidden = NO;
        }else
        {
            return;
        }
        
    }else
    {
        self.passField.hidden = YES;
        _sumLabel.text = [NSString stringWithFormat:@"%@元",_totalPrice];
        shengyuMoney = _totalPrice;
        
    }
    
}

- (IBAction)payBtn:(UIButton *)sender {
    
    sender.selected = YES;
    payStyle = sender.tag;
    if (sender.selected) {
        selected = sender.tag;
        NSArray* arr = [self.view subviews];
        for (UIButton* btn in arr) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if (btn.tag != sender.tag) {
                    btn.selected = NO;
                }
            }
        }
    }
    
}

- (IBAction)zhifu:(UIButton *)sender {
    
    if (payStyle == 12) {
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_ordernum,@"out_trade_no", nil];
        [payReq requestWitUrl:GETPAY_IF andArgument:dic andType:WXHTTPRequestGet];
        
        return;
    }
    
    if (![_sumLabel.text isEqualToString:@"0元"]) {
        
        if (payStyle == 0) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择支付方式" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            return;
        }
        [defaults setObject:_ordernum forKey:@"order_num"];
        [defaults setObject:_totalPrice forKey:@"order_money"];
        [defaults synchronize];
    }
    
    
    if (usecar) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"usePassword"]) {
            NSString* paypassword = [defaults objectForKey:@"paypassword"];
            if ([[MyMD5 md32:_passField.text ].lowercaseString isEqualToString:paypassword]) {
                NSString* uid = [defaults objectForKey:@"uid"];
                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_ordernum,@"ordernum",huiyuanpayMoney,@"ordermoney",uid,@"uid", nil];
                [huiyuanPay requestWitUrl:HUIYUANPAY andArgument:dic andType:WXHTTPRequestGet];
            }else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
        }else
        {
            NSString* uid = [defaults objectForKey:@"uid"];
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_ordernum,@"ordernum",huiyuanpayMoney,@"ordermoney",uid,@"uid", nil];
            [huiyuanPay requestWitUrl:HUIYUANPAY andArgument:dic andType:WXHTTPRequestGet];
        }
        
    }else{
        huiyuanpayMoney = @"0";
        [self payMoney];
    }
    
    //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhufuchenggong) name:@"zhifuchenggong" object:nil];
//        NSString* partner=@"2088811140537358";
//        NSString* seller=@"13935063031@163.com";
//        NSString* privateKey=@"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMhPBqpGjwSmmd7iU3PMVqUTCwrh7djU4pNs7I8ct3L9EiBjgn+uUTeoetDU4JYV7/EJFhSdcUhHobe04xZlHv69NzZbo9jQmgnc1qeJuk+gv3cbjOVZpgw3t7+XCrOCSknuBtxoxQTL9a2AId4tMl/2Qd1ccV5X31GH0CinaKdtAgMBAAECgYBV9Kt8iDi5GzDuVxrOl0IbJjfX3KmvIXN1JgnBQ+Zo/rY3ldwbJFeP1cmWMbOKVDGZsnd6MzG4fZyk84d7Rbtte6d/21saV7VmDWBLUVApeCZL7ecPnTMWU9bT4MRSotusFT8zByc8iMBnubKf47MHNDtzFvWOGL7M7Raif8Ln9QJBAPtOuL6ZVVtUzjd7Xh512zmo/REYS5LZ0B1NOIRQYzf5kqsIZiJl511ZlUK39jGgdsUfPBuoNEtbdYE0l4yeDy8CQQDMDIY3i2BgmaVlYONJ1ASd2lCs820f5j74pJ/tfHJlqFKKB7w+1PtVNEWpiyKqe3t5AW3FyoLO6GUBvdxvt6wjAkEAkDoBtQFzB1OIdjcLMRgalODzPBhhZwoycl6bDPTFvJ4zGo1bcGpjeiOrkfraBGk/QKpIaOcD/CulKF3yi/U6aQJAd6BoF6xYxomNlA/ncOMiCcFyRtM4CNmd1Xv+Xub00nCKY24BiPyolN1ecfWmTzixvNF/n9QIOHG6tfivgbe27QJAUFPhWqnXvqaBXWzLe9niFywxueDyFfcrwacmvsXPOEVn3Y3XsBOqJno59p3qucnLTcigzaEivIS3KAztXG0z4g==";
//        Order *order = [[Order alloc] init];
//        order.partner = partner;
//        order.seller = seller;
//        order.tradeNO =_ordernum; //订单ID（由商家自行制定）
//        order.productName = @"唐虎商品订单"; //商品标题
//        order.productDescription = @"faefae"; //商品描述
//        order.amount = @"0.01"; //商品价格
//        order.notifyURL = @"http://www.4001108383.com/apppay/notify_url.php"; //回调URL
//        
//        order.service = @"mobile.securitypay.pay";
//        order.paymentType = @"1";
//        order.inputCharset = @"utf-8";
//        order.itBPay = @"30m";
//        order.showUrl = @"m.alipay.com";
//        
//        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//        NSString *appScheme = @"O2O";
//        
//        //将商品信息拼接成字符串
//        NSString *orderSpec = [order description];
//        NSLog(@"orderSpec = %@",orderSpec);
//        
//        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//        id<DataSigner> signer = CreateRSADataSigner(privateKey);
//        NSString *signedString = [signer signString:orderSpec];
//        
//        //将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = nil;
//        if (signedString != nil) {
//            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                           orderSpec, signedString, @"RSA"];
//            
//            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
//             {
//                 NSLog(@"reslut = %@",resultDic);
//             }];
//            
//        }
//    }
    
    
    
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
