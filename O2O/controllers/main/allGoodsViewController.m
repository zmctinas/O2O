//
//  allGoodsViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "allGoodsViewController.h"
#import "cateDoodsTableViewCell.h"
#import "mainTableViewCell.h"
#import "multmenu.h"
#import "sortmenu.h"
#import "filtmenu.h"
#import "goodsDetailViewController.h"
#import "allMerModel.h"
#import "UIColor+hexColor.h"


@interface allGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    NSString* ispage;
    NSString* nextpage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSMutableDictionary* messageDic;

@property(strong,nonatomic)UILabel* label;

@property(strong,nonatomic)UIView* headerView;

@property(strong,nonatomic)multmenu* cateView;

@property(strong,nonatomic)sortmenu* sortView;

@property(strong,nonatomic)filtmenu* filtView;

@property(strong,nonatomic)UIView* backgroundView;

@property(strong,nonatomic)UIView* currentView;

@property(strong,nonatomic)UIView* contentView;

@end

@implementation allGoodsViewController
{
    NSInteger _index;
    HTTPRequest* _request;
    HTTPRequest* _request1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headerView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableSource = [[NSMutableArray alloc]init];
    
    self.navigationItem.titleView = self.label;
    
    [self registercell];
    
    NSArray* arr1 = @[@"超市",@"百货",@"美食",@"电影",@"KTV",@"酒店",@"团购"];
    NSArray* arr2 = @[@"默认排序",@"最新发布",@"销量最高",@"价格最低",@"价格最高"];
    _cateArr = [NSMutableArray arrayWithArray:arr1];
    _sortArr = [NSMutableArray arrayWithArray:arr2];
    _filtArr = [NSMutableArray arrayWithArray:arr2];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
    _contentView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchheader:) name:@"touchheaderView" object:nil];
    
    _request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:self.typeid,@"typeid",self.act,@"act",self.low,@"low",self.high,@"high",self.keyword,@"keyword", nil];
    _messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    [_request requestWitUrl:ALL_IF andArgument:dic andType:WXHTTPRequestGet];
    
    if (_btnName.length>0) {
        UIButton* btn = (UIButton*)[self.headerView viewWithTag:10];
        [btn setTitle:_btnName forState:UIControlStateNormal];
    }
    
    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.automaticallyRefresh = NO;
    [footer setTitle:@"已经加载到最后一页了" forState:MJRefreshStateNoMoreData];
    _tableView.footer = footer;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_messageDic setObject:@"1" forKey:@"page"];
        _request.tag = 1;
        [_request requestWitUrl:ALL_IF andArgument:_messageDic andType:WXHTTPRequestGet];
    }];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    _tableView.tableFooterView = [[UIView alloc]init];
    
//    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setFrame:CGRectMake(0, 0, 10, 15)];
//    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:[UIImage imageNamed:@"head_finish"] forState:UIControlStateNormal];
//    UIBarButtonItem* im = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = im;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)backBtn:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMoreData
{
    
    if ([ispage isEqualToString:@"1"]) {
        [_messageDic setObject:nextpage forKey:@"page"];
        _request.tag = 2;
        [_request requestWitUrl:ALL_IF andArgument:_messageDic andType:WXHTTPRequestGet];
    }else
    {
        [_tableView.footer endRefreshing];
    }

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    NSLog(@"%@",requestDic);
    ispage = requestDic[@"ispage"];
    nextpage = requestDic[@"nextpage"];
    NSString* message = requestDic[@"message"];
//    if ([message isEqualToString:@"1"]) {
    if (request.tag ==1) {
        [_tableSource removeAllObjects];
    }
        if (request == _request) {
            NSArray* commoditys = requestDic[@"goods"];
            
            for (NSDictionary* dic in commoditys) {
                allMerModel* model = [[allMerModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
                [_tableSource addObject:model];
            }
                [_tableView reloadData];
            [_tableView.footer endRefreshing];
            [_tableView.header endRefreshing];
        }else if (request == _request1)
        {
            
        }
    if ([ispage isEqualToString:@"0"]) {
        [self.tableView.footer noticeNoMoreData];
    }
        
            
//    }
    
}

#pragma mark - private

-(void)cancelSelcet
{
    [self touchheaderView:_selectBtn];
}

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"cateDoodsTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"catecell"];
    
    UINib* mainnib = [UINib nibWithNibName:@"mainTableViewCell" bundle:nil];
    [_tableView registerNib:mainnib forCellReuseIdentifier:@"maincell"];
}

-(void)touchheader:(NSNotification*)sender
{
    
    NSDictionary* dic = [sender userInfo];
    UIButton* btn = dic[@"btn"];
    [self touchheaderView:btn];
    
    if ([dic[@"type"] isEqualToString:@"1"]) {
        [_messageDic setObject:dic[@"id"] forKey:@"typeid"];
    }else if([dic[@"type"] isEqualToString:@"2"])
    {
        [_messageDic setObject:dic[@"act"] forKey:@"act"];
    }else
    {
        [_messageDic setObject:dic[@"low"] forKey:@"low"];
        [_messageDic setObject:dic[@"high"] forKey:@"high"];
    }
    _request.tag = 1;
    [_messageDic setValue:@"1" forKey:@"page"];
    [_request requestWitUrl:ALL_IF andArgument:_messageDic andType:WXHTTPRequestGet];
    
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

    }else{
        
    }
    
    _contentView.hidden = !sender.selected;
    _backgroundView.hidden = !sender.selected;
    
}

#pragma mark - getter

-(NSString*)typeid
{
    if (_typeid == nil) {
        _typeid = @"";
    }
    return _typeid;
}

-(NSString*)act
{
    if (_act == nil) {
        _act =@"";
    }
    return _act;
}

-(NSString*)low
{
    if (_low == nil) {
        _low = @"";
    }
    return _low;
}

-(NSString*)high
{
    if (_high == nil) {
        _high = @"";
    }
    return _high;
}

-(NSString*)keyword
{
    if (_keyword == nil) {
        _keyword = @"";
    }
    return _keyword;
}

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.text = @"全部产品";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:17];
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
        _sortView.contro = @"1";
    }
    return _sortView;
}

-(UIView*)cateView
{
    if (_cateView == nil) {
        _cateView = [[multmenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        _cateView.headerView = self.headerView;
        _cateView.contro = @"1";
    }
    return _cateView;
}

-(UIView*)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 39)];
        _headerView.layer.borderColor = [UIColor colorWithHexString:@"#E3E3E5"].CGColor;
        _headerView.layer.borderWidth = 0.5;
        
        for (int i = 0 ; i < 3; i++) {
            NSArray* arr = @[@"全部分类",@"默认排序",@"智能筛选"];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(i*SCREEN_WIDTH/3 , 5, SCREEN_WIDTH/3-10, 30)];
            [button setTitle:arr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#FF6392"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"arrdown"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"arrup"] forState:UIControlStateSelected];
            button.tag = i+10;
            _headerView.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(touchheaderView:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:button];
            _headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input"]];
        }
        
    }
    return _headerView;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == _tableView) {
//        switch (_index) {
//            case 0:
//                return 0;
//                break;
//                
//                
//            default:
//                return _tableSource.count;
//                break;
//        }
//    }
    if (_tableSource.count>0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else
    {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"maincell" forIndexPath:indexPath];
    
    cell.merModel = _tableSource[indexPath.row];

//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    goodsDetailViewController* goodsVC = [[goodsDetailViewController alloc]init];
    allMerModel* model = _tableSource[indexPath.row];
    goodsVC.commid = model.id;
    goodsVC.model = model;
    [self.navigationController pushViewController:goodsVC animated:YES];
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSIndexPath* indexpath = [_tableView indexPathForRowAtPoint:scrollView.contentOffset];
//    NSLog(@"%ld",indexpath.row);
//}


@end
