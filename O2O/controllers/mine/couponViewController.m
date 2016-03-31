//
//  couponViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "couponViewController.h"
#import "recomTableViewCell.h"
#import "UIColor+hexColor.h"

@interface couponViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* request;
    NSUserDefaults* defaults;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)UILabel* label;

@end

@implementation couponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableSource = [[NSMutableArray alloc]init];
    
    self.navigationItem.titleView = self.label;
    
    [self registercell];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString* uid = [defaults objectForKey:@"uid"];
    
    request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    [request requestWitUrl:MYCOUPON_IF andArgument:dic andType:WXHTTPRequestGet];
    
    
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
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"优惠券";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


#pragma mark - private

-(void)registercell
{
    UINib* recom = [UINib nibWithNibName:@"recomTableViewCell" bundle:nil];
    [_tableView registerNib:recom forCellReuseIdentifier:@"recomcell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    recomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"recomcell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
//    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor colorWithHexString:@"#949494"];
    label.text = @"为您推荐";
    [view addSubview:label];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
    [view addSubview:line];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

@end
