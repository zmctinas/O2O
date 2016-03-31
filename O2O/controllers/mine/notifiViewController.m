//
//  notifiViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "notifiViewController.h"
#import "notifiTableViewCell.h"
#import "couponTableViewCell.h"
#import "rootTableViewCell.h"
#import "couponViewController.h"
#import "youhuiModel.h"

@interface notifiViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* coupomReq;
    NSUserDefaults* defaults;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* _messageDic;
}

@property(strong,nonatomic)UIBarButtonItem* rightItem;

@property(strong,nonatomic)UILabel* label;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation notifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableSource = [[NSMutableArray alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registercell];
    
    self.navigationItem.titleView = self.label;
    
//    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString* uid = [defaults objectForKey:@"uid"];
    coupomReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    if (_type == WXMinecouponType) {
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
        _messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [coupomReq requestWitUrl:MYCOUPON_IF andArgument:dic andType:WXHTTPRequestGet];
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if ([ispage isEqualToString:@"1"]) {
                
                [_messageDic setValue:nextpage forKey:@"page"];
                [coupomReq requestWitUrl:MYCOUPON_IF andArgument:_messageDic andType:WXHTTPRequestGet];
            }else
            {
                [self.tableView.footer endRefreshing];
            }
        }];
    }else
    {
        [coupomReq requestWitUrl:NOTIFICATION_IF andArgument:nil andType:WXHTTPRequestGet];
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
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    if (_type == WXMinecouponType) {
        
        NSArray* point = requestDic[@"point"];
        for (NSDictionary* dic in point) {
            youhuiModel* model = [[youhuiModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        [_tableView reloadData];
        
    }else
    {
        ;
        NSArray* message = requestDic[@"message"];
        for (NSDictionary* dic in message) {
            youhuiModel* model = [[youhuiModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        [_tableView reloadData];
    }
    [_tableView.footer endRefreshing];
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        if (_type == WXMinecouponType) {
            _label.text = @"我的优惠券";
        }else
        {
            _label.text = @"消息通知";
        }
        
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* btn = [UIButton buttonWithType: UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 15, 15)];
        [btn setBackgroundImage:[UIImage imageNamed:@"recycle"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}

#pragma mark - private

-(void)touchBtn:(UIButton*)sender
{
    [_tableSource removeAllObjects];
    [_tableView reloadData];
}

-(void)registercell
{
    UINib* notifier = [UINib nibWithNibName:@"notifiTableViewCell" bundle:nil];
    [_tableView registerNib:notifier forCellReuseIdentifier:@"notifiercell"];
    
    UINib* coupon = [UINib nibWithNibName:@"couponTableViewCell" bundle:nil];
    [_tableView registerNib:coupon forCellReuseIdentifier:@"couponcell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString* identifier = [[NSMutableString alloc]initWithString:@"cell"];
    switch (_type) {
        case WXMinecouponType:
            [identifier insertString:@"coupon" atIndex:0];
            break;
        case WXMineNotifierType:
            [identifier insertString:@"notifier" atIndex:0];
            break;
            
        default:
            break;
    }
    
    
    rootTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.youhuiModel = _tableSource[indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_type == WXMinecouponType ) {
//        couponViewController* coupon = [[couponViewController alloc]init];
//        [self.navigationController pushViewController:coupon animated:YES];
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_type) {
        case WXMinecouponType:
            return 100;
            break;
        case WXMineNotifierType:
            return 60;
            break;
            
        default:
            break;
    }
}

@end
