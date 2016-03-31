//
//  moreViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "moreViewController.h"
#import "feedBackViewController.h"
#import "sharkViewController.h"
#import "sweepViewController.h"
#import "UMSocial.h"
#import "payHelpViewController.h"
#import "formyViewController.h"
#import "loginViewController.h"
#import "WXApi.h"

@interface moreViewController ()<UMSocialDataDelegate,UMSocialUIDelegate>

@property(strong,nonatomic) UILabel* label;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


- (IBAction)imageBtn:(UIButton *)sender;

- (IBAction)shareBtn:(UIButton *)sender;//分享设置

- (IBAction)aboutBtn:(UIButton *)sender;//关于我们

- (IBAction)feedbackBtn:(UIButton *)sender;//意见反馈

- (IBAction)payhelpBtn:(UIButton *)sender;//支付帮助

- (IBAction)sharkBtn:(UIButton *)sender;//摇一摇

- (IBAction)sweepBtn:(UIButton *)sender;//扫一扫

- (IBAction)selectBtn:(UIButton *)sender;


@end

@implementation moreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headbg"] forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger tmpsize = [[SDImageCache sharedImageCache] getSize];
    [_clearBtn setTitle:[NSString stringWithFormat:@"清理缓存(%dM)",tmpsize/1024/1024] forState:UIControlStateNormal];
    self.navigationItem.hidesBackButton = YES;
}

-(void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        _label.text = @"更多";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:17];
    }
    return _label;
}

#pragma mark - xib

- (IBAction)imageBtn:(UIButton *)sender {
    
    _selectBtn.selected = !_selectBtn.selected;
}

- (IBAction)shareBtn:(UIButton *)sender {
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:@[UMShareToSina]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        NSLog(@"fawef");
        [arr addObjectsFromArray:@[UMShareToTencent,UMShareToQzone,UMShareToQQ]];
    }
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"fawef");
        [arr addObjectsFromArray:@[UMShareToWechatSession,UMShareToWechatTimeline]];
    }
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"凯通商贸";
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"554876ba67e58e52450026ba"
                                      shareText:@"盂县目前设施最完备、功能最齐全、综合性最强的大型购物广场"
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:arr
                                       delegate:self];
    //调用快速分享接口
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"554876ba67e58e52450026ba"
//                                      shareText:@"盂县目前设施最完备、功能最齐全、综合性最强的大型购物广场"
//                                     shareImage:nil
//                                shareToSnsNames:nil
//                                       delegate:self];
    
}

-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

- (IBAction)aboutBtn:(UIButton *)sender {
    
    formyViewController* root = [[formyViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
}
- (IBAction)payhelpBtn:(UIButton *)sender {
    
    payHelpViewController* payhelp = [[payHelpViewController alloc]init];
    [self.navigationController pushViewController:payhelp animated:YES];
    
}
- (IBAction)sharkBtn:(UIButton *)sender {
    
    sharkViewController* root = [[sharkViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
}
- (IBAction)sweepBtn:(UIButton *)sender {
    
    sweepViewController* root = [[sweepViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
}
- (IBAction)feedbackBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        feedBackViewController* root = [[feedBackViewController alloc]init];
        [self.navigationController pushViewController:root animated:YES];
        
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }

}
- (IBAction)selectBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
        self.conn = [Reachability reachabilityForInternetConnection];
        [self.conn startNotifier];
    }else
    {
        [defaults setBool:NO forKey:@"isWifi"];
        [defaults synchronize];
        [self.conn stopNotifier];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    
}

- (void)networkStateChange
{
    [self checkNetworkState];
}

- (void)checkNetworkState
{
         // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
//         // 2.检测手机是否能上网络(WIFI\3G\2.5G)
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
         // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable)
    { // 有wifi
        NSLog(@"有wifi");
        
        isWifi = YES;
    }
    
    isWifi = NO;
    
    [defaults setBool:isWifi forKey:@"isWifi"];
    [defaults synchronize];
    
//    } else if ([conn currentReachabilityStatus] != NotReachable)
//    { // 没有使用wifi, 使用手机自带网络进行上网
//        NSLog(@"使用手机自带网络进行上网");
//        
//    } else { // 没有网络
//        NSLog(@"没有网络");
//    }
}

#pragma mark - UMSocialUIDelegate

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (IBAction)clearImg:(UIButton *)sender {
    
        [[SDImageCache sharedImageCache] clearDisk];
        
        //    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    NSInteger tmpsize = [[SDImageCache sharedImageCache] getSize];
    [_clearBtn setTitle:[NSString stringWithFormat:@"清理缓存(%dM)",tmpsize/1024/1024] forState:UIControlStateNormal];
    
}
@end
