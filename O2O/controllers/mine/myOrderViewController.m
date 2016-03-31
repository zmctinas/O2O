//
//  myOrderViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/24.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "myOrderViewController.h"
#import "AppDelegate.h"
#import "myOrderTableViewCell.h"
#import "detailModel.h"
#import "orderdetailViewController.h"
#import "orderModel.h"
#import "evaluateViewController.h"
#import "backMoneyViewController.h"
#import "gopayViewController.h"
#import "UIColor+hexColor.h"
#import "carMineModel.h"

@interface myOrderViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* orderReq;
    NSUserDefaults* defaults;
    HTTPRequest* deleteReq;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* _messageDic;
    HTTPRequest* getReq;
}

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)UILabel* label;

- (IBAction)navBtn:(UIButton *)sender;

@end

@implementation myOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registercell];
    
    self.navigationItem.titleView = self.label;
    
    _tableSource = [[NSMutableArray alloc]init];
    
    [self initnavBtn];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    orderReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    deleteReq = [[HTTPRequest alloc]initWithtag:2 andDelegate:self];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        orderReq.tag = 1;
        [_messageDic setValue:@"1" forKey:@"page"];
        [orderReq requestWitUrl:ALLORDER_IF andArgument:_messageDic andType:WXHTTPRequestGet];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([ispage isEqualToString:@"1"]) {
            orderReq.tag = 2;
            [_messageDic setValue:nextpage forKey:@"page"];
            [orderReq requestWitUrl:ALLORDER_IF andArgument:_messageDic andType:WXHTTPRequestGet];
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
    [self requestOrder];
    
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
    
    if (request == orderReq) {
        ispage = requestDic[@"ispage"];
        nextpage = requestDic[@"nextpage"];
        NSArray* order = requestDic[@"order"];
        if (request.tag == 1) {
            [_tableSource removeAllObjects];
        }
        
        for (NSDictionary* shopDic in order) {
            carMineModel* shopModel = [[carMineModel alloc]init];
            [shopModel setValuesForKeysWithDictionary:shopDic];
            NSArray* goods = shopDic[@"goods"];
            for (NSDictionary* dic in goods) {
                orderModel* model = [[orderModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [shopModel.shopArr addObject:model];
            }
            [_tableSource addObject:shopModel];
        }
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (request.tag ==1) {
            [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }else if (request == deleteReq)
    {
        
        NSString* message = requestDic[@"message"];
        if ([message isEqualToString:@"1"]) {
            [self requestOrder];
        }
    }else if (request == getReq)
    {
        NSString* message = requestDic[@"message"];
        if ([message isEqualToString:@"1"]) {
            [self requestOrder];
        }
    }
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"我的订单";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark - private

-(void)requestOrder
{
    
    orderReq.tag = 1;
    NSString* uid = [defaults objectForKey:@"uid"];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_act,@"act",@"1",@"page", nil];
    _messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [orderReq requestWitUrl:ALLORDER_IF andArgument:dic andType:WXHTTPRequestGet];
}

-(void)tapBtn:(UIButton*)sender
{
    if ([sender.currentTitle isEqualToString:@"取消订单"]) {
        carMineModel* model = _tableSource[sender.tag];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:model.ordernum,@"ordernum", nil];
        [deleteReq requestWitUrl:ORDERDELETE_IF andArgument:dic andType:WXHTTPRequestGet];
    }else if ([sender.currentTitle isEqualToString:@"删除订单"])
    {
        carMineModel* model = _tableSource[sender.tag];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:model.ordernum,@"ordernum", nil];
        [deleteReq requestWitUrl:ORDERDELETE_IF andArgument:dic andType:WXHTTPRequestGet];
    }else if ([sender.currentTitle isEqualToString:@"申请退款"])
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂不支持线上退款" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"哦，知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        
//        backMoneyViewController* root = [[backMoneyViewController alloc]init];
//        carMineModel* model = _tableSource[sender.tag];
//        root.totalMoney = model.totmoney;
//        root.orderid = model.ordernum;
//        [self.navigationController pushViewController:root animated:YES];
    }else if ([sender.currentTitle isEqualToString:@"评价订单"])
    {
        orderModel* model = _tableSource[sender.tag];
        evaluateViewController* root = [[evaluateViewController alloc]init];
        root.model = model;
        root.selectType = 1;
        [self.navigationController pushViewController:root animated:YES];
        
    }else if ([sender.currentTitle isEqualToString:@"立即支付"])
    {
        UIApplication* app = [UIApplication sharedApplication];
        AppDelegate* delegate = app.delegate;
        delegate.delegate = self;
        carMineModel* model = _tableSource[sender.tag];
        gopayViewController* root = [[gopayViewController alloc]init];
        root.ordernum = model.ordernum;
        root.yueMoney = [defaults objectForKey:@"money"];
        root.totalPrice = [NSString stringWithFormat:@"%0.2f",model.totmoney.floatValue];
        [self.navigationController pushViewController:root animated:YES];
    }else if ([sender.currentTitle isEqualToString:@"确认收货"])
    {
        
        getReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
        carMineModel* model = _tableSource[sender.tag];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:model.ordernum,@"ordernum", nil];
        [getReq requestWitUrl:GETGOODS_IF andArgument:dic andType:WXHTTPRequestGet];
        
        
    }else if ([sender.currentTitle isEqualToString:@"提醒发货"])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在发货，请稍等..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)initnavBtn
{
    
    [_oneBtn setTitleColor:[UIColor colorWithHexString:@"#FF5185"] forState:UIControlStateSelected];
    [_twoBtn setTitleColor:[UIColor colorWithHexString:@"#FF5185"] forState:UIControlStateSelected];
    [_threeBtn setTitleColor:[UIColor colorWithHexString:@"#FF5185"] forState:UIControlStateSelected];
    [_fourBtn setTitleColor:[UIColor colorWithHexString:@"#FF5185"] forState:UIControlStateSelected];
    [_fifBtn setTitleColor:[UIColor colorWithHexString:@"#FF5185"] forState:UIControlStateSelected];
    
    
    NSInteger num = 0;
    switch (_type) {
        case WXMyOrderAll:
            num = 0;
            break;
        case WXMyOrderUnPay:
            num = 1;
            break;
        case WXMyOrderUnSend:
            num = 2;
            break;
        case WXMyOrderUnReceive:
            num = 3;
            break;
        case WXMyOrderUnEvaluate:
            num = 4;
            break;
            
        default:
            break;
    }
    
    
//    if (num>2) {
//        [self moveLineLabel:num-1];
//    }else
//    {
        [self moveLineLabel:num];
//    }
    UIButton* btn = (UIButton*)[self.view viewWithTag:num + 10];
    btn.selected = YES;
}

-(void)registercell
{
    UINib* order = [UINib nibWithNibName:@"myOrderTableViewCell" bundle:nil];
    [_tableView registerNib:order forCellReuseIdentifier:@"ordercell"];
}

-(void)moveLineLabel:(NSInteger)index
{
    __block CGRect lineFrame  = _lineLabel.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        _lineLeft.constant =index* SCREEN_WIDTH /5 ;
//        lineFrame.origin.x = index* SCREEN_WIDTH /5;
//        _lineLabel.frame = lineFrame;
    }];
}

#pragma mark - xib

- (IBAction)navBtn:(UIButton *)sender {
    
    NSInteger num = sender.tag - 10;
//    if (num>2) {
//        [self moveLineLabel:num-1];
//    }else
//    {
        [self moveLineLabel:num];
//    }
    
    
    _act = [NSString stringWithFormat:@"%ld",num];
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

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    carMineModel* model = _tableSource[section];
    return model.shopArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ordercell" forIndexPath:indexPath];
    
    carMineModel* mineModel = _tableSource[indexPath.section];
    cell.typeLabel.text = mineModel.checkinfo;
    cell.orderModel = mineModel.shopArr[indexPath.row];
//    [cell addDelegate:self andAction:@selector(tapBtn:)];
//    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderdetailViewController* root = [[orderdetailViewController alloc]init];
    carMineModel* shopModel = _tableSource[indexPath.section];
    orderModel* model = shopModel.shopArr[indexPath.row];
    root.ordModel = model;
    [self.navigationController pushViewController:root animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    carMineModel* model = _tableSource[section];
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithHexString:@"#FF658E"];
    [backView addSubview:view];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 20)];
    shanghu.text = model.title;
    shanghu.textAlignment = NSTextAlignmentLeft;
    shanghu.textColor = [UIColor whiteColor];
    [view addSubview:shanghu];
    
    UILabel* danhao = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 5, 150, 20)];
    danhao.text = model.ordernum;
    danhao.textAlignment = NSTextAlignmentRight;
    danhao.textColor = [UIColor whiteColor];
    danhao.adjustsFontSizeToFitWidth = YES;
    [view addSubview:danhao];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    [backView addSubview:view1];
    UILabel* dingdantime = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 70, 20)];
    dingdantime.text = @"下单时间:";
    dingdantime.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:dingdantime];
    
    UILabel* time = [[UILabel alloc]initWithFrame:CGRectMake(72, 8, 160, 20)];
    time.text = model.posttime;
    time.font = [UIFont systemFontOfSize:14];
    time.textColor = [UIColor colorWithHexString:@"#818181"];
    [view1 addSubview:time];
    
    UILabel* stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(234, 8, 80, 20)];
    stateLabel.text = model.checkinfo;
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont systemFontOfSize:14];
    stateLabel.textColor = [UIColor colorWithHexString:@"#FF638E"];
    [view1 addSubview:stateLabel];
    
    
    return backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    carMineModel* model = _tableSource[section];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    UILabel* zongjia = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 40, 20)];
    zongjia.text = @"共计:";
    
    [view addSubview:zongjia];
    
    UILabel* price = [[UILabel alloc]initWithFrame:CGRectMake(45, 5, 120, 20)];
    [view addSubview:price];
    
    if (model.postmoney.floatValue>0) {
        NSString* text = [NSString stringWithFormat:@"￥%@邮费:(￥%@)",model.totmoney,model.postmoney];
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:text];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHexString:@"#FF658E"]
                       range:NSMakeRange(0, model.totmoney.length+1)];
        price.adjustsFontSizeToFitWidth = YES;
        price.attributedText = string;
    }else
    {
        price.text = model.totmoney;
        price.textColor = [UIColor colorWithHexString:@"#FF658E"];
        price.adjustsFontSizeToFitWidth = YES;
        
    }
    
//    UILabel* postLabel = [UILabel alloc]initWithFrame:CGRectMake(150, 5, <#CGFloat width#>, <#CGFloat height#>)
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(170, 3, 70, 25)];
    [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius = 3;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
    leftBtn.layer.borderWidth = 0.5;
    leftBtn.tag = section;
    [leftBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(245, 3, 70, 25)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn.png"] forState:UIControlStateNormal];
    rightBtn.tag = section;
    [rightBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    
    int act = model.act.intValue;
    
    switch (act) {
        case 1:
            
            [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            
            break;
        case 2:
            
            [leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            leftBtn.hidden = YES;
            [rightBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
            break;
        case 3:
            
            [leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            leftBtn.hidden = YES;
            [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
            break;
        case 4:
            
            [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            leftBtn.hidden = YES;
            [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            
            break;
            
            
            
        default:
            break;
    }
    
    
    
//    if (act<=4&& act!= 3&&act!=2) {
//        leftBtn.hidden = NO;
//        rightBtn.hidden = NO;
//    }else if (act == 3||act == 2)
//    {
//        rightBtn.hidden = NO;
//        leftBtn.hidden = YES;
//    }
//    else
//    {
//        leftBtn.hidden = YES;
//        rightBtn.hidden = YES;
//    }
//    if (act == 4) {
//        leftBtn.hidden = YES;
//    }else
//    {
//        leftBtn.hidden = NO;
//    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

@end
