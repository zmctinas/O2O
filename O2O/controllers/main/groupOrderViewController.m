//
//  groupOrderViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "groupOrderViewController.h"
#import "gopayViewController.h"
#import "youhuiModel.h"
#import "youhuiBottom.h"

@interface groupOrderViewController ()<HTTPRequestDataDelegate,bottomprotrol>
{
    HTTPRequest* tuangouReq;
    NSUserDefaults* defaults;
    float price;
    float sum;
    HTTPRequest* useReq;
    NSMutableArray* _tableSource;
    youhuiModel* selectModel;
}

@property(strong,nonatomic)UILabel* label;

- (IBAction)orderBtn:(UIButton *)sender;

@end

@implementation groupOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    tuangouReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    useReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    [self createUI];
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
    if (request == tuangouReq) {
        
        if ([message isEqualToString:@"1"]) {
            gopayViewController* root = [[gopayViewController alloc]init];
            root.ordernum = requestDic[@"id"];
            root.yueMoney = requestDic[@"money"];
            NSArray* arr = [_xiaojiLabel.text componentsSeparatedByString:@"￥"];
            root.totalPrice = arr[1];
            [self.navigationController pushViewController:root animated:YES];
        }
    }else if (request == useReq)
    {
        if ([message isEqualToString:@"1"]) {
            NSArray* point = requestDic[@"point"];
            NSMutableArray* dateArr = [[NSMutableArray alloc]init];
            for (NSDictionary* dic in point) {
                youhuiModel* model = [[youhuiModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [dateArr addObject:model];
            }
            if (dateArr.count>0) {
                
                youhuiBottom* bottom = [[youhuiBottom alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [self.view addSubview:bottom];
                bottom.delegate = self;
                bottom.tableSource = dateArr;
                [bottom show];
                
            }else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无可用优惠券" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
   
    
    
}

-(void)sendMessage:(youhuiModel *)model
{
    selectModel = model;
    [_youhuiBtn setTitle:[NSString stringWithFormat:@"%@     金额%@元",model.title,model.money] forState:UIControlStateNormal];
    _zongjiaLabel.text = [NSString stringWithFormat:@"%0.2f",sum - selectModel.money.floatValue];
}

#pragma mark - private

-(void)createUI
{
    
    _addressLabel.text = _messageDic[@"address"];
    _phoneLabel.text = _messageDic[@"phoneNum"];
    _comNameLabel.text = _messageDic[@"name"];
    price = [_messageDic[@"price"] floatValue];
    sum = price ;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_messageDic[@"price"]];
    _xiaojiLabel.text = [NSString stringWithFormat:@"￥%@",_messageDic[@"price"]];
    _zongjiaLabel.text = [NSString stringWithFormat:@"%@",_messageDic[@"price"]];
    
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"生成团购券";
        _label.font = [UIFont boldSystemFontOfSize:17];
        
    }
    
    return _label;
}

- (IBAction)orderBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    NSString* userName = [defaults objectForKey:@"userName"];
    
    if (_numLabel.text.integerValue>3) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您最多还能购买%@件该商品",_messageDic[@"canbuynum"]] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_messageDic[@"gid"],@"gid",userName,@"username",_numLabel.text,@"num", nil];
    NSMutableDictionary* orderDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    if (selectModel) {
        [orderDic setObject:selectModel.password forKey:@"coupon_pwd"];
    }
    
    [tuangouReq requestWitUrl:CREATEGROUPCOUPON_IF andArgument:orderDic andType:WXHTTPRequestGet];
    
    
    
}
- (IBAction)numBtn:(UIButton *)sender {
    
    [_youhuiBtn setTitle:@"点击选择优惠券" forState:UIControlStateNormal];
    selectModel = nil;
    
    NSInteger num = [_numLabel.text integerValue];
    if (sender.tag == 10) {
        if (num>1) {
            num--;
        }
    }else
    {
        num++;
    }
    _numLabel.text = [NSString stringWithFormat:@"%d",num];
    
    sum = price*num;
    _xiaojiLabel.text = [NSString stringWithFormat:@"￥%0.2f",sum];
    _zongjiaLabel.text = [NSString stringWithFormat:@"%0.2f",sum];
}

- (IBAction)couponBtn:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",[NSString stringWithFormat:@"%f",sum],@"money",_messageDic[@"gid"],@"gid", nil];
    [useReq requestWitUrl:USEABLE_IF andArgument:dic andType:WXHTTPRequestGet];
    
}

@end
