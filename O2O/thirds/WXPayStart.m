//
//  WXPayStart.m
//  TiaoWei
//
//  Created by dukai on 15/3/9.
//  Copyright (c) 2015年 longcai. All rights reserved.
//

#import "WXPayStart.h"
#import "WXApi.h"
//#import "APService.h"
#import "payRequsestHandler.h"

static WXPayStart * WXP = nil;
@implementation WXPayStart
{
    long      token_time;
    NSString * Token;
}
+(WXPayStart *)share{
    if(WXP ==nil){
        WXP = [[WXPayStart alloc]init];
        //向微信注册
        [WXApi registerApp:@"wx8dd56f745ff0d6ea" withDescription:@"demo 2.0"];

    }
    return WXP;
}
- (void)sendPay:(NSString *)orderNum amount:(NSString *)amount orderName:(NSString *)orderName
{
    
     
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:orderNum price:amount orderName:orderName];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
       //  [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
       // [WXApi safeSendReq:req];
        [WXApi sendReq:req];
    }
}

@end
