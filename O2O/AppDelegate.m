//
//  AppDelegate.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "AppDelegate.h"
#import "startViewController.h"
#import "eventViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "APService.h"
#import "RootViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>





#define appkey @"554876ba67e58e52450026ba"

@interface AppDelegate ()<WXApiDelegate,HTTPRequestDataDelegate>
{
    HTTPRequest* weixinReq;
}

@end

@implementation AppDelegate{
    RootViewController *rootViewController;
}

-(void)initrootVC
{
    _goods = [[NSMutableArray alloc]init];
    NSString* isFirst = [[NSUserDefaults standardUserDefaults]objectForKey:@"isfirst"];
    if (isFirst) {
        startViewController* rootVC = [[startViewController alloc]init];
        self.window.rootViewController = rootVC;
    }else
    {
        eventViewController* rootVC = [[eventViewController alloc]init];
        self.window.rootViewController = rootVC;
    }
    
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
//    [[AlipaySDK defaultService] processOrderWithPaymentResult:url
//                                              standbyCallback:^(NSDictionary *resultDic)
//     {
//         
//         
//         if ([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]) {
//             
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifubao" object:nil];
//             
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggong" object:nil];
//         }
//     }];
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic)
        {
            
            if ([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifubao" object:nil];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggong" object:nil];
            }
        }];
        
      }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
        
    }
//
    [WXApi handleOpenURL:url delegate:self];
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];;
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FrameSize setScreen:screenIphone5];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self initrootVC];
    
    //[self clearDefaults];
    
    [UMSocialData setAppKey:appkey];
    [UMSocialQQHandler setQQWithAppId:@"1104749146" appKey:appkey url:@"http://115.28.133.70/interface/mobile/fenxiang.php"];
    [UMSocialWechatHandler setWXAppId:@"wx8dd56f745ff0d6ea" appSecret:appkey url:@"http://115.28.133.70/interface/mobile/fenxiang.php"];//wx8dd56f745ff0d6ea
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [WXApi registerApp:@"wx8dd56f745ff0d6ea" withDescription:@"demo 2.0"];
    
    [self.window makeKeyAndVisible];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        NSMutableSet *categories = [NSMutableSet set];
        
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        
        category.identifier = @"identifier";
        
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        
        action.identifier = @"test2";
        
        action.title = @"test";
        
        action.activationMode = UIUserNotificationActivationModeBackground;
        
        action.authenticationRequired = YES;
        
        //YES显示为红色，NO显示为蓝色
        action.destructive = NO;
        
        NSArray *actions = @[ action ];
        
        [category setActions:actions forContext:UIUserNotificationActionContextMinimal];
        
        [categories addObject:category];
    }
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    rootViewController = [[RootViewController alloc]init];
    [rootViewController create];
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    [rootViewController addNotificationCount];
    
}


//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)   (UIBackgroundFetchResult))completionHandler {
    
    
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    [rootViewController addNotificationCount];
    
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//    NSString* uid = [userInfo valueForKey:@"RegistrationID"];
    
    
    
    
//    CLLocationCoordinate2D coordinate2D;
//    coordinate2D.latitude = 100.0;
//    coordinate2D.longitude = 100.0;
//    CLRegion *currentRegion =
//    [[CLCircularRegion alloc] initWithCenter:coordinate2D
//                                      radius:CLLocationDistanceMax
//                                  identifier:@"test"];
    
//    [APService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:120]
//                          alertBody:@"test ios8 notification"
//                              badge:0
//                        alertAction:@"取消"
//                      identifierKey:@"1"
//                           userInfo:nil
//                          soundName:nil
//                             region:nil
//                 regionTriggersOnce:YES
//                           category:@"test"];
    
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}


- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

-(void) onResp:(BaseResp*)resp{
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        
        if (resp.errCode ==0 )
        {
            //成功
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postData" object:self userInfo:nil];
            
        }
        else
        {
            //失败
        }
        NSString* trade_status = nil;
        switch (resp.errCode)
        {
            case WXSuccess:
                //                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                trade_status = @"TRADE_SUCCESS";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifubao" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggong" object:nil];
                break;
                
            default:
                //                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                trade_status = @"TRADE_FAILE";
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        NSString* order=[defaults objectForKey:@"order_num"];
        NSString* moner=[defaults objectForKey:@"order_money"];
        NSString* uid = [defaults objectForKey:@"uid"];
        NSString* zhpay = [defaults objectForKey:@"zhpay"];
        
        if (!zhpay.length>0) {
            zhpay = @"0";
        }
        
        weixinReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",order,@"out_trade_no",moner,@"total_fee",trade_status,@"trade_status",zhpay,@"zhpay", nil];
        
//        [weixinReq requestWitUrl:WEIDIAO andArgument:dic andType:WXHTTPRequestGet];
    }
}

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    if ([message isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggong" object:nil];
    }
}

@end
