//
//  collectViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "collectViewController.h"
#import "recommendTableViewCell.h"
#import "categoryModel.h"
#import "collectModel.h"
#import "goodsDetailViewController.h"
#import "allMerModel.h"

@interface collectViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    NSMutableArray* _moveArr;
    HTTPRequest* collectRequest;
    NSInteger page;
    HTTPRequest* deleteReq;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* _messageDic;
}

@property(strong,nonatomic)UIButton* deleteBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(strong,nonatomic)UILabel* label;


@end

@implementation collectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    page = 1;
    
    self.navigationItem.titleView = self.label;
    
    _tableSource = [[NSMutableArray alloc]init];
    _moveArr = [[NSMutableArray alloc]init];
    
    [self regitecell];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view addSubview:self.deleteBtn];
    self.deleteBtn.hidden = YES;
    
    deleteReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    collectRequest = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* uid = [defaults objectForKey:@"uid"];
    
    NSDictionary* dic =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    _messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [collectRequest requestWitUrl:MYCOLLECT_IF andArgument:dic andType:WXHTTPRequestGet];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([ispage isEqualToString:@"1"]) {
            
            [_messageDic setValue:nextpage forKey:@"page"];
            [collectRequest requestWitUrl:MYCOLLECT_IF andArgument:_messageDic andType:WXHTTPRequestGet];
        }else
        {
            [self.tableview.footer endRefreshing];
        }
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    self.deleteBtn.hidden = !editing;
    CGRect rect = _tableview.frame;
    
    if (editing) {
        rect.size.height -= 40;
    }else
    {
        rect.size.height +=40;
    }
    _tableview.frame = rect;
    
    [_moveArr removeAllObjects];
    [self setbtntitle];
    
    [_tableview setEditing:editing animated:animated];
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
    
    if (request == collectRequest) {
        
        NSArray* collect = requestDic[@"collect"];
        
        ispage = requestDic[@"ispage"];
        
        nextpage = requestDic[@"nextpage"];
        
        for (NSDictionary* dic  in collect) {
            
            collectModel* model = [[collectModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            model.descriptions = dic[@"description"];
            
            [_tableSource addObject:model];
            
        }
        
        [_tableview reloadData];
        
        [self.tableview.footer endRefreshing];
        
    }else if (request == deleteReq)
        
    {
        
        NSString* message = requestDic[@"message"];
        
        if ([message isEqualToString:@"1"]) {
            [_tableSource removeObjectsInArray:_moveArr];
            [_tableview reloadData];
            [_moveArr removeAllObjects];
            [self setbtntitle];
            
        }
        
    }
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"我的收藏";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

-(UIButton*)deleteBtn
{
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setFrame:CGRectMake(10, SCREEN_HEIGHT - 44 - 45, SCREEN_WIDTH - 20, 30)];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn.png"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];

    }
    return _deleteBtn;
}

#pragma mark - private

-(void)setbtntitle
{
    if (_moveArr.count ==0) {
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else
    {
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",(unsigned long)_moveArr.count] forState:UIControlStateNormal];
    }
}

-(void)deleBtn:(UIButton*)sender
{
    
    NSMutableString* collectid = [[NSMutableString alloc]init];
    for (int i = 0 ;i<_moveArr.count;i++) {
        collectModel* model = _moveArr[i];
        if (i!= 0) {
            [collectid appendString:@","];
        }
        [collectid appendString:model.collectid];
        
    }
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:collectid,@"collectid", nil];
    [deleteReq  requestWitUrl:DELETECOLLECT_IF andArgument:dic andType:WXHTTPRequestGet];
    
    
}

-(void)regitecell
{
    UINib* collect = [UINib nibWithNibName:@"recommendTableViewCell" bundle:nil];
    [_tableview registerNib:collect forCellReuseIdentifier:@"collectcell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    recommendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"collectcell" forIndexPath:indexPath];
    
    cell.collectModel = _tableSource[indexPath.row];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_tableSource.count == section +1) {
        return 0.01;
    }else if (_tableSource.count==0)
    {
        return 0.01;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_tableSource.count== 0) {
        return 5;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete |UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableview.editing) {
        [_moveArr addObject:_tableSource[indexPath.row]];
        [self setbtntitle];
    }else
    {
        collectModel* colmodel = _tableSource[indexPath.row];
        allMerModel* model = [[allMerModel alloc]init];
        model.comName = colmodel.comName;
        model.commodityID = colmodel.commodityID;
        model.smallPic = colmodel.commodityPic;
        model.bigPic = colmodel.commodityPic;
        model.currentprice = colmodel.currentprice;
        model.originalprice = colmodel.originalprice;
        model.descriptions = colmodel.descriptions;
        goodsDetailViewController* root = [[goodsDetailViewController alloc]init];
        root.model = model;
        root.commid = colmodel.commodityID;
        [self.navigationController pushViewController:root animated:YES];
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = _tableSource[indexPath.row];
    if ([_moveArr containsObject:obj]) {
        [_moveArr removeObject:obj];
    }
    [self setbtntitle];
}

@end
