//
//  commerListViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/10/26.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "commerListViewController.h"
#import "mainTableViewCell.h"
#import "allMerModel.h"
#import "goodsDetailViewController.h"

@interface commerListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* _tableSource;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* messageDic;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;




@end

@implementation commerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableSource = [NSMutableArray array];
    _tableView.tableFooterView = [[UIView alloc]init];
    messageDic = [NSMutableDictionary dictionaryWithDictionary:@{@"commid":_commid,@"page":@"1"}];
    
    [self registercell];
    [self requestData];
    [self setUpRefresh];
    
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

#pragma mark - private

-(void)loadMoreData
{
    self.view.tag = 2;
    if (ispage.integerValue == 1) {
        [messageDic setObject:nextpage forKey:@"page"];
        [self requestData];
    }else
    {
        [_tableView.footer endRefreshing];
    }
}

-(void)setUpRefresh
{
    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.automaticallyRefresh = NO;
    [footer setTitle:@"已经加载到最后一页了" forState:MJRefreshStateNoMoreData];
    _tableView.footer = footer;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [messageDic setObject:@"1" forKey:@"page"];
        self.view.tag = 1;
        [self requestData];
    }];
}

-(void)registercell
{
    UINib* mainnib = [UINib nibWithNibName:@"mainTableViewCell" bundle:nil];
    [_tableView registerNib:mainnib forCellReuseIdentifier:@"maincell"];
}

-(void)requestData
{
    
    [HTTPRequest requestWitUrl:COMMER_GOODS_IF andArgument:messageDic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        if (self.view.tag == 1) {
            [_tableSource removeAllObjects];
        }
        ispage = requestDic[@"ispage"];
        nextpage = requestDic[@"nextpage"];
        NSArray* goods = requestDic[@"goods"];
        for (NSDictionary* dic in goods) {
            allMerModel* model = [[allMerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (ispage.integerValue == 0) {
            [_tableView.footer noticeNoMoreData];
        }
    } Falsed:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    mainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"maincell" forIndexPath:indexPath];
    cell.merModel = _tableSource[indexPath.row];
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
    
    allMerModel* model = _tableSource[indexPath.row];
    goodsDetailViewController* detail = [[goodsDetailViewController alloc]init];
    detail.commid = model.id;
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
