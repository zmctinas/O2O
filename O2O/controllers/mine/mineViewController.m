//
//  mineViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "mineViewController.h"
#import "registerViewController.h"
#import "loginViewController.h"
#import "UIColor+hexColor.h"
#import "setViewController.h"
#import "creditsViewController.h"
#import "collectViewController.h"
#import "cardViewController.h"
#import "notifiViewController.h"
#import "otherViewController.h"
#import "goodsViewController.h"
#import "myOrderViewController.h"
#import "feedBackViewController.h"
#import "groupTicketViewController.h"
#import "allCouponViewController.h"
#import "cartViewController.h"

@interface mineViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,HTTPRequestDataDelegate>
{
    NSUserDefaults* defaults;
    HTTPRequest* headReq;
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property(strong,nonatomic) UIBarButtonItem* rightItem;

@property(strong,nonatomic) UIBarButtonItem* leftItem;

@property(strong,nonatomic) UIImagePickerController* imagePicker;

@property(strong,nonatomic)UILabel* label;


- (IBAction)loginBtn:(UIButton *)sender;//登录

- (IBAction)detailBtn:(UIButton *)sender;//明细

- (IBAction)convert:(UIButton *)sender;//兑换

- (IBAction)collectBtn:(UIButton *)sender;//收藏

- (IBAction)carstore:(UIButton *)sender;//购物车

- (IBAction)groupTicket:(UIButton *)sender;//团购券

- (IBAction)cardBtn:(UIButton *)sender;//会员卡

- (IBAction)notifiBtn:(UIButton *)sender;//消息通知

- (IBAction)recommend:(UIButton *)sender;//推荐

- (IBAction)addressBtn:(UIButton *)sender;//地址

- (IBAction)feedbackBtn:(UIButton *)sender;//反馈

- (IBAction)allcouponBtn:(UIButton *)sender;


- (IBAction)couponBtn:(UIButton *)sender;//优惠券

- (IBAction)myOrderBtn:(UIButton *)sender;//订单

- (IBAction)orderBtn:(UIButton *)sender;

- (IBAction)paizhaoBtn:(UIButton *)sender;

- (IBAction)xiangceBtn:(UIButton *)sender;

- (IBAction)touchBack:(id)sender;


@end

@implementation mineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 2;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = self.label;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    UIView* conView = (UIView*)[_scrollView viewWithTag:99];
    self.scrollView.contentSize = CGSizeMake(0, conView.frame.origin.y+conView.frame.size.height+15);
    self.scrollView.showsVerticalScrollIndicator = NO;

    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    self.backView.hidden = YES;
    
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds =YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapiconView:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_iconView addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL isLogin = [defaults boolForKey:@"isLogin"];
    if (!isLogin) {
        _headView.hidden = YES;
        _loginBtn.hidden = NO;
        _iconView.image = [UIImage imageNamed:@"loding1"];
        self.navigationItem.leftBarButtonItem = self.leftItem;
        
    }else
    {
        _headView.hidden = NO;
        _loginBtn.hidden = YES;
        self.navigationItem.leftBarButtonItem = nil;
        
        NSString* imgUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,[defaults objectForKey:@"headImage"]];
        [_iconView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
        
        
        [self requestData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    
    if (request == headReq) {
        NSString* message = requestDic[@"message"];
        NSString* content = nil;
        NSInteger num = [message integerValue];
        
        switch (num) {
            case 1:
                content = @"成功";
                [defaults setObject:requestDic[@"picurl"] forKey:@"headImage"];
                [defaults synchronize];
                break;
            case 2:
                content = @"重复";
                break;
            case 3:
                content = @"失败";
                break;
                
            default:
                break;
        }
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        
    }
}

#pragma marl - getter

-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 20, 20)];
        [button setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapSet:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _rightItem;
}

-(UIBarButtonItem*)leftItem
{
    if (_leftItem == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 50, 20)];
//        [button setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _leftItem;
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"我的";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

#pragma mark - private

-(void)updateMessage
{
    _nameLabel.text = [defaults objectForKey:@"userName"];
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",[defaults objectForKey:@"money"]];
}

-(void)requestData

{
    NSString* uid = [defaults objectForKey:@"uid"];
    NSDictionary* dic = @{@"uid":uid};
    [HTTPRequest requestWitUrl:MYMessage_if andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSArray* ziliao = requestDic[@"ziliao"];
        NSDictionary* messagDic = [ziliao firstObject];
        
        if (messagDic) {
            [defaults setObject:messagDic[@"money"] forKey:@"money"];
            [defaults setObject:messagDic[@"integral"] forKey:@"integral"];
            [defaults setObject:messagDic[@"username"] forKey:@"userName"];
            [defaults synchronize];
            [self updateMessage];
        }
        
        
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)changephoto:(UIImage*)image
{
    self.iconView.image = image;
    
    headReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    NSString* uid = [defaults objectForKey:@"uid"];
    NSString* base = [UIImageJPEGRepresentation(image,0.4) base64EncodedStringWithOptions:0];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",base,@"base", nil];
    [headReq requestWitUrl:USERAVATAR_IF andArgument:dic andType:WXHTTPRequestPost];
    
}

-(void)keyboardhidden
{
    _backView.hidden = YES;
}

-(void)tapiconView:(UITapGestureRecognizer*)tap
{
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        self.backView.hidden = NO;
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        [self.navigationController pushViewController:root animated:YES];
    }
    
}

-(void)tapSet:(UIButton*)sender
{
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        setViewController* setVC = [[setViewController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(changephoto:) withObject:orgImage afterDelay:0.1];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - xib

- (IBAction)carstore:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid == nil) {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }else
    {
    cartViewController* car = [[cartViewController alloc]init];
    [self.navigationController pushViewController:car
                                         animated:YES];
    }
}

- (IBAction)groupTicket:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        groupTicketViewController* root = [[groupTicketViewController alloc]init];
        root.act = @"2";
        [self.navigationController pushViewController:root animated:YES];
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        [self.navigationController pushViewController:root animated:YES];
    }
    
}

- (IBAction)cardBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        cardViewController* card = [[cardViewController alloc]init];
        [self.navigationController pushViewController:card animated:YES];
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
    
}

- (IBAction)loginBtn:(UIButton *)sender {
    
    loginViewController* root = [[loginViewController alloc]init];
    
    [self.navigationController pushViewController:root animated:YES];
    
}

- (IBAction)detailBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        creditsViewController* credit = [[creditsViewController alloc]init];
        credit.type = WXCreditDetailType;
        [self.navigationController pushViewController:credit animated:YES];
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
    
}

- (IBAction)convert:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        creditsViewController* credit = [[creditsViewController alloc]init];
        credit.type = WXCreditConvertType;
        [self.navigationController pushViewController:credit animated:YES];
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
    
}

- (IBAction)collectBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        collectViewController* collect = [[collectViewController alloc]init];
        
        [self.navigationController pushViewController:collect animated:YES];
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
    
}
- (IBAction)notifiBtn:(UIButton *)sender {
    
    notifiViewController* notifier = [[notifiViewController alloc]init];
    notifier.type = WXMineNotifierType;
    [self.navigationController pushViewController:notifier animated:YES];
    
}
- (IBAction)recommend:(UIButton *)sender {
    
    
    otherViewController* other = [[otherViewController alloc]init];
    other.type = WXCommdityRecommendType;
    other.ismine = @"1";
    [self.navigationController pushViewController:other animated:YES];
    
    
}
- (IBAction)addressBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        goodsViewController* goods = [[goodsViewController alloc]init];
        [self.navigationController pushViewController:goods animated:YES];

    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
}

- (IBAction)allcouponBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        allCouponViewController* root = [[allCouponViewController alloc]init];
        [self.navigationController pushViewController:root animated:YES];
        
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
    
}

- (IBAction)couponBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        notifiViewController* coupon = [[notifiViewController alloc]init];
        coupon.type = WXMinecouponType;
        [self.navigationController pushViewController:coupon animated:YES];
        
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
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
- (IBAction)myOrderBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        myOrderViewController* root = [[myOrderViewController alloc]init];
        root.type = WXMyOrderAll;
        root.act = @"0";
        [self.navigationController pushViewController:root animated:YES];
        
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
    
}
- (IBAction)orderBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid != nil) {
        myOrderViewController* root = [[myOrderViewController alloc]init];
        NSInteger num = sender.tag - 10;
        switch (num) {
            case 0:
                root.type = WXMyOrderUnPay;
                root.act = @"1";
                break;
            case 1:
                root.type = WXMyOrderUnSend;
                root.act = @"2";
                break;
            case 2:
                root.type = WXMyOrderUnReceive;
                root.act = @"3";
                break;
            case 3:
                root.type = WXMyOrderUnEvaluate;
                root.act = @"4";
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:root animated:YES];
        
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        
        [self.navigationController pushViewController:root animated:YES];
    }
    
   
    
}

- (IBAction)paizhaoBtn:(UIButton *)sender {
    
    [self keyboardhidden];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];

}

- (IBAction)xiangceBtn:(UIButton *)sender {
    
    [self keyboardhidden];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (IBAction)touchBack:(id)sender {
    
    [self keyboardhidden];
    
}
//- (IBAction)loginBtn:(UIButton *)sender {
//}
@end
