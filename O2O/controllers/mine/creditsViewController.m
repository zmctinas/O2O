//
//  creditsViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "creditsViewController.h"
#import "rootTableViewCell.h"
#import "convertTableViewCell.h"
#import "detailTableViewCell.h"
#import "UIColor+hexColor.h"
#import "credetialViewController.h"
#import "allMerModel.h"


@interface creditsViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    NSString* _headers;
    HTTPRequest* request;
    NSUserDefaults* defaults;
    NSMutableDictionary* mudic;
    NSString* ispage;
    NSString* nextpage;
}

@property(nonatomic)WXCreditType btnType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;

@property (weak, nonatomic) IBOutlet UIButton *creditBtn;

@property(strong,nonatomic)UILabel* label;

- (IBAction)creditBtn:(UIButton *)sender;

@end

@implementation creditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _creditBtn.layer.cornerRadius = 3;
    _creditBtn.layer.masksToBounds = YES;
    
    _tableSource = [[NSMutableArray alloc]init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.navigationItem.titleView = self.label;
    
    [self regitecell];
    
    _btnType = _type;
    
    if (_btnType == WXCreditRecordType) {
        [_creditBtn setTitle:@"积分明细" forState:UIControlStateNormal];
        _btnType = WXCreditDetailType;
        _headers = @"兑换记录";
       
    }
    else
    {
        [_creditBtn setTitle:@"兑换记录" forState:UIControlStateNormal];
        _btnType = WXCreditRecordType;
        _headers = @"积分明细";
        
    }
    
    
    
    NSString* url = nil;
    NSString* uid = [defaults objectForKey:@"uid"];
    mudic = [[NSMutableDictionary alloc]init];
    switch (_type) {
        case WXCreditConvertType:
            self.creditBtn.hidden = YES;
            url = INTEGRAL_IF;
            break;
        case WXCreditDetailType:
            
            url = INTEDETIAL;
            [mudic setObject:@"1" forKey:@"type"];
            
            [mudic setObject:uid forKey:@"uid"];
            break;
        case WXCreditRecordType:
            [mudic setObject:@"2" forKey:@"type"];
            [mudic setObject:uid forKey:@"uid"];
            url = INTEDETIAL;
            break;
            
        default:
            break;
    }
    
    request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    [request requestWitUrl:url andArgument:mudic andType:WXHTTPRequestGet];
    
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (ispage.integerValue ==  1) {
            [mudic setObject:nextpage forKey:@"page"];
            [request requestWitUrl:url andArgument:mudic andType:WXHTTPRequestGet];
        }else
        {
            [self.tableView.footer endRefreshing];
        }
    }];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:15];
        if (_type == WXCreditConvertType) {
            _label.text = @"积分商城";
        }else
        {
            _label.text = @"积分明细";
        }
    }
    return _label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* integral = [defaults objectForKey:@"integral"];
    if (integral) {
        _creditsLabel.text = integral;
    }else
    {
        _creditsLabel.text = @"0";
    }
    
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
    
    NSLog(@"%@",requestDic);
    ispage = requestDic[@"ispage"];
    nextpage = requestDic[@"nextpage"];
    
    if (_type == WXCreditConvertType) {
        NSArray* commoditys = requestDic[@"commoditys"];
        [_tableSource removeAllObjects];
        for (NSDictionary* dic in commoditys) {
            allMerModel* model = [[allMerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        
    }else if (_type == WXCreditDetailType)
    {
        NSArray* integral = requestDic[@"integral"];
        [_tableSource removeAllObjects];
        for (NSDictionary* dic  in integral) {
            allMerModel* model = [[allMerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        
        
    }else if (_type == WXCreditRecordType)
    {
        NSArray* integral = requestDic[@"integral"];
        [_tableSource removeAllObjects];
        for (NSDictionary* dic  in integral) {
            allMerModel* model = [[allMerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        
    }
    [self.tableView.footer endRefreshing];
    [_tableView reloadData];
}

#pragma mark - private

-(void)initBtn
{
    if (_btnType == WXCreditRecordType) {
        [_creditBtn setTitle:@"积分明细" forState:UIControlStateNormal];
        _btnType = WXCreditDetailType;
        _headers = @"兑换记录";
        _type = WXCreditDetailType;
        [mudic setObject:@"2" forKey:@"type"];
    }else
    {
        [_creditBtn setTitle:@"兑换记录" forState:UIControlStateNormal];
        _btnType = WXCreditRecordType;
        _headers = @"积分明细";
        _type = WXCreditRecordType;
        [mudic setObject:@"1" forKey:@"type"];
    }
    [request requestWitUrl:INTEDETIAL andArgument:mudic andType:WXHTTPRequestGet];
}

-(void)regitecell
{
    UINib* convert = [UINib nibWithNibName:@"convertTableViewCell" bundle:nil];
    [_tableView registerNib:convert forCellReuseIdentifier:@"convertcell"];
    UINib* detail = [UINib nibWithNibName:@"detailTableViewCell" bundle:nil];
    [_tableView registerNib:detail forCellReuseIdentifier:@"detailcell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString* identifier = [[NSMutableString alloc]initWithString:@"cell"];
    switch (_type) {
        case WXCreditConvertType:
            [identifier insertString:@"convert" atIndex:0];
            break;
        case WXCreditDetailType:
            [identifier insertString:@"detail" atIndex:0];
            break;
        case WXCreditRecordType:
            [identifier insertString:@"detail" atIndex:0];
            break;
        default:
            break;
    }
    
    rootTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (_type == WXCreditDetailType) {
        cell.typeid = @"1";
    }else if (_type == WXCreditRecordType)
    {
        cell.typeid = @"2";
    }
    
    allMerModel* model = _tableSource[indexPath.row];
    cell.merModel = model;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == WXCreditConvertType) {
        credetialViewController* root = [[credetialViewController alloc]init];
        
        allMerModel* model = _tableSource[indexPath.row];
        root.model = model;
        [self.navigationController pushViewController:root animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == WXCreditConvertType) {
        return 90;
    }else
    {
        return 80;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel* back = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    back.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [view addSubview:back];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
    if (_type == WXCreditConvertType) {
        label.text = @"积分兑换";
    }else
    {
        label.text = _headers;
    }
    
    [view addSubview:label];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E1DDDE"];
    [view addSubview:line];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - xib

- (IBAction)creditBtn:(UIButton *)sender {
    
    [self initBtn];
    [_tableView reloadData];
    
}
@end
