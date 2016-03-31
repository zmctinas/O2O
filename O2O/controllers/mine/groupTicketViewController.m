//
//  groupTicketViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "groupTicketViewController.h"
#import "detailModel.h"
#import "groupTableViewCell.h"
#import "ticketViewController.h"
#import "couponModel.h"
#import "backMoneyViewController.h"
#import "AppDelegate.h"
#import "gopayViewController.h"
#import "UIColor+hexColor.h"
#import "evaluateViewController.h"

@interface groupTicketViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* _request;
    NSUserDefaults* defaults;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* _messageDic;
    HTTPRequest* otherReq;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)UILabel* label;


@end

@implementation groupTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.titleView = self.label;
    
    _tableSource = [[NSMutableArray alloc]init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self registercell];
    [self initnavBtn];
    
    
    
    _request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    otherReq =[[HTTPRequest alloc]initWithtag:2 andDelegate:self];
   
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([ispage isEqualToString:@"1"]) {
            _request.tag = 2;
            [_messageDic setValue:nextpage forKey:@"page"];
            [_request requestWitUrl:MYGROUPCOU_IF andArgument:_messageDic andType:WXHTTPRequestGet];
        }else
        {
            [self.tableView.footer endRefreshing];
        }
    }];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestOrder];
    }];
    
    NSString* uid = [defaults objectForKey:@"uid"];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",@"1",@"page",@"2",@"act", nil];
    _messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
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
    
    
    [_request requestWitUrl:MYGROUPCOU_IF andArgument:_messageDic andType:WXHTTPRequestGet];
    
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
    NSLog(@"%@",requestDic);
    if (request == _request) {
        ispage = requestDic[@"ispage"];
        nextpage = requestDic[@"nextpage"];
        NSArray* groupcoupon = requestDic[@"groupcoupon"];
        if (request.tag != 2) {
            [_tableSource removeAllObjects];
        }
        for (NSDictionary* dic in groupcoupon) {
            couponModel* model = [[couponModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }else if (request == otherReq)
    {
        NSString* message = requestDic[@"message"];
        if ([message isEqualToString:@"1"]) {
            [self requestOrder];
        }
    }
}

#pragma mark - getter

-(NSString*)act
{
    if (_act == nil) {
        _act = @"";
    }
    return _act;
}

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"团购券";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark - private

-(void)tapBtn:(UIButton*)sender
{
    if ([sender.currentTitle isEqualToString:@"取消订单"]) {
        couponModel* model = _tableSource[sender.tag];
        NSString* uid = [defaults objectForKey:@"uid"];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",model.id,@"id", nil];
        [otherReq requestWitUrl:DELETEGROUP_IF andArgument:dic andType:WXHTTPRequestGet];
    }else if ([sender.currentTitle isEqualToString:@"删除订单"])
    {
        couponModel* model = _tableSource[sender.tag];
        NSString* uid = [defaults objectForKey:@"uid"];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",model.groupcoupon,@"id", nil];
        [otherReq requestWitUrl:DELETEGROUP_IF andArgument:dic andType:WXHTTPRequestGet];
    }else if ([sender.currentTitle isEqualToString:@"申请退款"])
    {
        
        backMoneyViewController* root = [[backMoneyViewController alloc]init];
        couponModel* model = _tableSource[sender.tag];
        root.totalMoney = model.salesprice;
        root.orderid = model.groupcoupon;
        [self.navigationController pushViewController:root animated:YES];
    }else if ([sender.currentTitle isEqualToString:@"立即支付"])
    {
        UIApplication* app = [UIApplication sharedApplication];
        AppDelegate* delegate = app.delegate;
        delegate.delegate = self;
        couponModel* model = _tableSource[sender.tag];
        gopayViewController* root = [[gopayViewController alloc]init];
        root.ordernum = model.groupcoupon;
        root.yueMoney = [defaults objectForKey:@"money"];
        root.totalPrice = [NSString stringWithFormat:@"%0.2f",model.salesprice.floatValue];
        [self.navigationController pushViewController:root animated:YES];
    }else if ([sender.currentTitle isEqualToString:@"评价订单"])
    {
        couponModel* model = _tableSource[sender.tag];
        evaluateViewController* root = [[evaluateViewController alloc]init];
        root.couModel = model;
        root.selectType = 2;
        [self.navigationController pushViewController:root animated:YES];
        
    }
}

-(void)requestOrder
{
    _request.tag = 1;
    [_messageDic setObject:self.act forKey:@"act"];
    [_messageDic setObject:@"1" forKey:@"page"];
    [_request requestWitUrl:MYGROUPCOU_IF andArgument:_messageDic andType:WXHTTPRequestGet];
}

-(void)initnavBtn
{
    
    [_firstBtn setTitleColor:[UIColor colorWithHexString:@"#FF5185"] forState:UIControlStateSelected];
    [_sencondBtn setTitleColor:[UIColor colorWithHexString:@"#FF5185"] forState:UIControlStateSelected];
    [_thirdBtn setTitleColor:[UIColor colorWithHexString:@"#FF5185"] forState:UIControlStateSelected];
    
    
    NSInteger num = 1;
    
    [self moveLineLabel:num];
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:num + 10];
    btn.selected = YES;
}

-(void)moveLineLabel:(NSInteger)index
{
    __block CGRect lineFrame  = _lineLabel.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        _lineLeft.constant = index* SCREEN_WIDTH /4;
//        lineFrame.origin.x = index* SCREEN_WIDTH /3;
        _lineLabel.frame = lineFrame;
    }];
}

-(void)registercell
{
    UINib* ticket = [UINib nibWithNibName:@"groupTableViewCell" bundle:nil];
    [_tableView registerNib:ticket forCellReuseIdentifier:@"ticketcell"];
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
    groupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ticketcell" forIndexPath:indexPath];
    
    cell.coupModel = _tableSource[indexPath.section];
    [cell addDelegate:self andAction:@selector(tapBtn:)];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ticketViewController* root = [[ticketViewController alloc]init];
//    [self.navigationController pushViewController:root animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}



- (IBAction)navBtn:(UIButton *)sender {
    
    NSInteger num = sender.tag - 10;
    [self moveLineLabel:num];
    
    _act = [NSString stringWithFormat:@"%d",num+1];
    [self requestOrder];
    
    sender.selected = YES;
    NSArray* arr = [self.view subviews];
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag != sender.tag) {
                btn.selected = NO;
            }
        }
    }
    
}
@end
