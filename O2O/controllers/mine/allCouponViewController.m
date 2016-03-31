//
//  allCouponViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/6/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "allCouponViewController.h"
#import "youhuiModel.h"
#import "allcouponTableViewCell.h"

@interface allCouponViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* allcouponReq;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* _messageDic;
}
@property(strong,nonatomic)UILabel* label;

@end

@implementation allCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    _tableSource = [[NSMutableArray alloc]init];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.titleView = self.label;
    
    [self registercell];
    
    allcouponReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"page", nil];
    _messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [allcouponReq requestWitUrl:ALLCOUPON_IF andArgument:dic andType:WXHTTPRequestGet];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([ispage isEqualToString:@"1"]) {
            
            [_messageDic setValue:nextpage forKey:@"page"];
            [allcouponReq requestWitUrl:ALLCOUPON_IF andArgument:_messageDic andType:WXHTTPRequestGet];
        }else
        {
            [self.tableView.footer endRefreshing];
        }
    }];
    
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
    
    ispage = requestDic[@"ispage"];
    nextpage = requestDic[@"nextpage"];
    NSArray* coupon = requestDic[@"coupon"];
    for (NSDictionary* dic  in coupon) {
        youhuiModel* model = [[youhuiModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_tableSource addObject:model];
    }
    [_tableView reloadData];
    [self.tableView.footer endRefreshing];
}

#pragma mark - private

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"全部优惠券";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

-(void)registercell
{
    UINib* allcoupin = [UINib nibWithNibName:@"allcouponTableViewCell" bundle:nil];
    [_tableView registerNib:allcoupin forCellReuseIdentifier:@"coupon"];
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
    rootTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"coupon" forIndexPath:indexPath];
    
    cell.youhuiModel = _tableSource[indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

@end
