//
//  MerGoodsViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "MerGoodsViewController.h"
#import "merTableViewCell.h"
#import "multmenu.h"
#import "sortmenu.h"
#import "filtmenu.h"
#import "MerchantDetailViewController.h"
#import "commerModel.h"
#import "UIColor+hexColor.h"


@interface MerGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tabelSource;
    NSInteger _index;
    HTTPRequest* _request;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* _messageDic;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *dropMenu;

@property(strong,nonatomic)UIButton* selectBtn;

@property(strong,nonatomic)NSMutableDictionary* requestDic;

@property(strong,nonatomic)UIView* headerView;

@property(strong,nonatomic)sortmenu* cateView;

@property(strong,nonatomic)sortmenu* sortView;

@property(strong,nonatomic)filtmenu* filtView;

@property(strong,nonatomic)UIView* backgroundView;

@property(strong,nonatomic)UIView* currentView;

@property(strong,nonatomic)UIView* contentView;

@property(strong,nonatomic)UILabel* label;

@end

@implementation MerGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabelSource = [[NSMutableArray alloc]init];
    
    [self registercell];
    _tableView.layer.borderColor = [UIColor colorWithHexString:@"#E8E8E8"].CGColor;
    _tableView.layer.borderWidth = 0.5;
    
    self.navigationItem.titleView = self.label;
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
    _contentView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchmerchant:) name:@"touchmerchant" object:nil];
    
    [_dropMenu addSubview:self.headerView];
    
    _request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:1],@"page",self.typeid,@"typeid",self.shangquanid,@"shangquanid", nil];
    _requestDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    _messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [_request requestWitUrl:COMMER_IF andArgument:dic andType:WXHTTPRequestGet];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([ispage isEqualToString:@"1"]) {
            _request.tag = 2;
            [_requestDic setValue:nextpage forKey:@"page"];
            [_request requestWitUrl:COMMER_IF andArgument:_requestDic andType:WXHTTPRequestGet];
        }else
        {
            [self.tableView.footer endRefreshing];
        }
    }];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _request.tag = 1;
        [_requestDic setValue:@"1" forKey:@"page"];
        [_request requestWitUrl:COMMER_IF andArgument:_requestDic andType:WXHTTPRequestGet];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchmerchant" object:nil];
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    
    NSArray* commercial = requestDic[@"commercial"];
    ispage = requestDic[@"ispage"];
    nextpage = requestDic[@"nextpage"];
    if (request.tag != 2) {
        [_tabelSource removeAllObjects];
    }
    
    for (NSDictionary* dic in commercial) {
        commerModel* model = [[commerModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_tabelSource addObject:model];
    }
    [_tableView reloadData];
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

#pragma mark - private

-(void)cancelSelcet
{
    [self touchheaderView:_selectBtn];
}

-(void)registercell
{
    UINib* merchant = [UINib nibWithNibName:@"merTableViewCell" bundle:nil];
    [_tableView registerNib:merchant forCellReuseIdentifier:@"merchantcell"];
}

-(void)touchmerchant:(NSNotification*)sender
{
    NSDictionary* dic = [sender userInfo];
    UIButton* btn = dic[@"btn"];
    [self touchheaderView:btn];
    NSString* type = dic[@"type"];
    if ([type isEqualToString:@"1"]) {
        _typeid = dic[@"id"];
        [_requestDic setObject:_typeid forKey:@"typeid"];
    }else if ([type isEqualToString:@"3"])
    {
        [_requestDic setObject:dic[@"act"] forKey:@"typeid"];
        
    }else
    {
        _shangquanid = dic[@"act"];
        [_requestDic setObject:_shangquanid forKey:@"act"];
    }
    _request.tag = 1;
    [_requestDic setObject:@"1" forKey:@"page"];
    [_request requestWitUrl:COMMER_IF andArgument:_requestDic andType:WXHTTPRequestGet];
}

-(void)touchheaderView:(UIButton*)sender
{
    NSInteger num = sender.tag;
    sender.selected = !sender.selected;
    _index = num ;
    _selectBtn = sender;
    
    
    NSArray* arr = [_headerView subviews];
    for (id obj in arr) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton*)obj;
            if (btn.tag != sender.tag) {
                btn.selected = NO;
            }
        }
    }
    
    
    
    
    if (sender.selected) {
        [_currentView removeFromSuperview];
        switch (num) {
            case 10:
                
                _currentView = self.cateView;
                [_contentView addSubview:_cateView];
                
                
                break;
            case 11:
                
                _currentView = self.sortView;
                [_contentView addSubview:_sortView];
                break;
            case 12:
                _currentView = self.filtView;
                [_contentView addSubview:_filtView];
                break;
                
            default:
                break;
        }
        //        [_contentView addSubview:_currentView];
        //        [self.view addSubview:_contentView];
    }else{
        
    }
    
    _contentView.hidden = !sender.selected;
    _backgroundView.hidden = !sender.selected;
    //    [_tableView reloadData];
    
}

#pragma mark - getter

-(NSString*)typeid
{
    if (_typeid == nil) {
        _typeid = @"";
    }
    return _typeid;
}

-(NSString*)shangquanid
{
    if (_shangquanid == nil) {
        _shangquanid = @"";
    }
    return _shangquanid;
}

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"全部商家";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


-(UIView*)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 130)];
    }
    return _contentView;
}

-(UIView*)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 94)];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.7;
        _backgroundView.hidden = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSelcet)];
        [_backgroundView addGestureRecognizer:tap];
    }
    
    return _backgroundView;
}

-(UIView*)filtView
{
    if (_filtView == nil) {
        _filtView = [[filtmenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        _filtView.headerView = self.headerView;
        
    }
    return _filtView;
}

-(UIView*)sortView
{
    if (_sortView ==nil) {
        _sortView = [[sortmenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        _sortView.headerView = self.headerView;
        _sortView.contro = @"2";
    }
    return _sortView;
}

-(UIView*)cateView
{
    if (_cateView == nil) {
        _cateView = [[sortmenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        _cateView.headerView = self.headerView;
        _cateView.contro = @"3";
    }
    
    return _cateView;
}

-(UIView*)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        
        for (int i = 0 ; i < 2; i++) {
            NSArray* arr = @[@"全部分类",@"智能排序",@"智能排序"];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(i*SCREEN_WIDTH/2 , 5, SCREEN_WIDTH/3+20, 30)];
            button.center = CGPointMake((2*i+1)*SCREEN_WIDTH/4, 20);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#FF6E9A"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"arrdown"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"arrup"] forState:UIControlStateSelected];
            button.tag = i+10;
            _headerView.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(touchheaderView:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:button];

        }
        
    }
    return _headerView;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_tabelSource.count>0) {
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    }else
//    {
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
    return _tabelSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    merTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchantcell" forIndexPath:indexPath];
    
    cell.comModel = _tabelSource[indexPath.row];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MerchantDetailViewController* root = [[MerchantDetailViewController alloc]init];
    
    commerModel* model = _tabelSource[indexPath.row];
    root.comID = model.id;
    root.model = model;
    [self.navigationController pushViewController:root animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

@end
