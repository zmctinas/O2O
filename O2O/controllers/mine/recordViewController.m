//
//  recordViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "recordViewController.h"
#import "UIColor+hexColor.h"
#import "recordTableViewCell.h"
#import "detailModel.h"
#import "recordModel.h"
#import "UIColor+hexColor.h"

@interface recordViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    NSUserDefaults* defaults;
    HTTPRequest* request;
    NSString* url;
    CGRect tableFrame;
}

@property(strong,nonatomic)UILabel* label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *balance;



@end

@implementation recordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
//    _tableView.layer.borderWidth = 0.5;
//    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input.png"]];
    tableFrame = _tableView.frame;
    _tableSource = [[NSMutableArray alloc]initWithCapacity:1];
    
    [self registercell];
    
    if (_recordType == WXCreditRecordPay) {
        self.label.text = @"充值记录";
        url = CHARGEREC_IF;
    }else
    {
        self.label.text = @"使用记录";
        url = USEREC_IF;
    }
    self.navigationItem.titleView = self.label;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString* uid = [defaults objectForKey:@"uid"];
    NSString* money = [defaults objectForKey:@"money"];
    _balance.text = [NSString stringWithFormat:@"￥%@",money];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    
    request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    [request requestWitUrl:url andArgument:dic andType:WXHTTPRequestGet];
    
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
    
    NSArray* jilu = requestDic[@"jilu"];
    for (NSDictionary* dic in jilu) {
        recordModel* model = [[recordModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_tableSource addObject:model];
    }
    [self performSelector:@selector(changetableViewFrame) withObject:nil afterDelay:0.1];
    
    
}

#pragma mark - private

-(void)changetableViewFrame
{
//    CGRect tableViewFrame = _tableView.frame;
//    tableViewFrame.size.height =(_tableSource.count*30+40)>tableFrame.size.height?tableFrame.size.height:(_tableSource.count*30+40);
//    _tableView.frame = tableViewFrame;
//    NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    [_tableView reloadData];
}

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:17];
    }
    return _label;
}

-(void)registercell
{
    UINib* use = [UINib nibWithNibName:@"recordTableViewCell" bundle:nil];
    [_tableView registerNib:use forCellReuseIdentifier:@"usecell"];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    recordTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"usecell" forIndexPath:indexPath];
    if (_recordType == WXCreditRecordPay) {
        cell.type = 1;
    }else
    {
        cell.type = 0;
    }
    cell.reModel = _tableSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    NSArray* arr;
    if (_recordType == WXCreditRecordPay) {
        arr = @[@"充值时间",@"充值金额",@"充值状态"];
    }else
    {
        arr = @[@"订单号",@"消费时间",@"消费金额"];
    }
    
    for (int i = 0 ; i< 3; i++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(i*self.tableView.frame.size.width/3 , 0, self.tableView.frame.size.width/3, 40)];
        label.text = arr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHexString:@"#282828"];
        [view addSubview:label];
        if (i>0) {
            UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(i*self.tableView.frame.size.width/3, 0, 1, 40)];
            line.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            [view addSubview:line];
        }
        
        
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

@end
