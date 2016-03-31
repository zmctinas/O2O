//
//  goodsViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "goodsViewController.h"
#import "goodsTableViewCell.h"
#import "addressManageViewController.h"
#import "adressModel.h"

@interface goodsViewController ()<UITableViewDataSource,UITableViewDelegate,WXAddressDelegate,HTTPRequestDataDelegate>
{
    HTTPRequest* selectReq;
    NSUserDefaults* defaults;
    HTTPRequest* editReq;
}

@property(strong,nonatomic)UILabel* label;

- (IBAction)newaddress:(UIButton *)sender;


@end

@implementation goodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
   
    _tableSource = [[NSMutableArray alloc]init];

    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UINib* nib   =[UINib nibWithNibName:@"goodsTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"goodscell"];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    
    view.hidden = YES;

    
    NSString* uid = [defaults objectForKey:@"uid"];
    selectReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    [selectReq requestWitUrl:MYADDRESS_IF andArgument:dic andType:WXHTTPRequestGet];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    if (request == selectReq) {
        
        [_tableSource removeAllObjects];
        NSArray* address = requestDic[@"address"];
        for (NSDictionary* dic in address) {
            adressModel* model = [[adressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            [_tableSource addObject:model];
        }
        
        [_tableView reloadData];
    }else if (request == editReq)
    {
        
        if ([requestDic[@"message"] isEqualToString:@"1"]) {
            [_tableView reloadData];
            if ([_delegate respondsToSelector:@selector(changeAddress)]) {
                [_delegate performSelector:@selector(changeAddress)];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"收货地址管理";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark - private

-(void)touchselect:(goodsTableViewCell*)cell
{
    NSIndexPath* indexpath = [_tableView indexPathForCell:cell];
    adressModel* model = _tableSource[indexpath.section];
    
    model.is_first = @"1";
    
    for (int i = 0;i<_tableSource.count;i++) {
        if (i!=indexpath.section) {
            adressModel* md = _tableSource[i];
            md.is_first = @"0";
        }
    }
    
    editReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSString* uid = [defaults objectForKey:@"uid"];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",model.id,@"id", nil];
    [editReq requestWitUrl:EDITADDRESS_IF andArgument:dic andType:WXHTTPRequestGet];
    
    
    
    
}

#pragma mark - WXAddressDelegate

-(void)sendAddress:(addressModel *)model
{
    [_tableSource addObject:model];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

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
    goodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"goodscell" forIndexPath:indexPath];
    
    adressModel* model = _tableSource[indexPath.section];
    [cell addselectBtnStatestarget:self andAction:@selector(touchselect:)];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (IBAction)newaddress:(UIButton *)sender {
    
    addressManageViewController* root = [[addressManageViewController alloc]init];
    root.delegate = self;
    [self.navigationController pushViewController:root animated:YES];
    
}
@end
