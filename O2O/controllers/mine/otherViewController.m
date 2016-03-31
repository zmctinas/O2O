//
//  otherViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "otherViewController.h"
#import "rootTableViewCell.h"
#import "recommendViewController.h"
#import "integralTableViewCell.h"
#import "saleTableViewCell.h"
#import "UIColor+hexColor.h"
#import "convertTableViewCell.h"
#import "allMerModel.h"
#import "countdown.h"
#import "credetialViewController.h"
#import "goodsDetailViewController.h"

@interface otherViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* _messageDic;
    NSString* url;
    HTTPRequest* request;
    NSUserDefaults* defaults;
}

@property (weak, nonatomic) IBOutlet countdown *time;

@property(strong,nonatomic)UILabel* label;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *flagLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation otherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableSource = [[NSMutableArray alloc]init];
    
    self.headView.layer.borderWidth = 0.4;
    self.headView.layer.borderColor = [UIColor colorWithHexString:@"#EFEFF4"].CGColor;
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString* integral = [defaults objectForKey:@"integral"];
    
    _time.type = @"2";
    [self regitecell];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.tableView setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    }
    
    self.navigationItem.titleView = self.label;
    
    switch (_type) {
        case WXCommdityRecommendType:
            self.flagLabel.text = @"荐";
//            _titleLabel.text = @"2015-04-13（周四）14：50更新";
            url = RECOMMEND_IF;
            _time.hidden = YES;
            break;
        case WXCommdityConvertType:
            self.flagLabel.text = @"积";
            _titleLabel.text = [NSString stringWithFormat:@"剩余积分：%@",integral];
            url = INTEGRAL_IF;
            _time.hidden = YES;
            break;
        case WXCommditySaleType:
            self.flagLabel.text = @"秒";
            _titleLabel.text = @"剩余时间:";
            url = FLASH_IF;
            _time.hidden = NO;
            break;
            
        default:
            break;
    }
    [self footerview];
    
    request = [[HTTPRequest alloc]init];
    request.delegate = self;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"page", nil];
    _messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [request requestWitUrl:url andArgument:_messageDic andType:WXHTTPRequestGet];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self requestOrder];
        [_messageDic setObject:@"1" forKey:@"page"];
        request.tag = 1;
        [request requestWitUrl:url andArgument:_messageDic andType:WXHTTPRequestGet];
    }];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)footerview
{
    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.automaticallyRefresh = NO;
    NSMutableString* message = [[NSMutableString alloc]initWithString:@"点击查看更多"];
    switch (_type) {
        case WXCommdityRecommendType:
            [message appendString:@"推荐"];
            break;
        case WXCommdityConvertType:
            [message appendString:@"商品"];
            break;
        case WXCommditySaleType:
            [message appendString:@"商品"];
            break;
            
        default:
            break;
    }
    [footer setTitle:message forState:MJRefreshStateIdle];
    [footer setTitle:@"正在努力加载..." forState:MJRefreshStateRefreshing];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    footer.stateLabel.textColor = [UIColor colorWithHexString:@"#ee6a89"];
    
    _tableView.footer = footer;
    
}

-(void)loadMoreData
{
    NSLog(@"%@",NSStringFromClass([ispage class]));
    if ([ispage isEqualToString:@"1"]) {
        [_messageDic setObject:nextpage forKey:@"page"];
        request.tag = 2;
        [request requestWitUrl:url andArgument:_messageDic andType:WXHTTPRequestGet];
    }else
    {
        [_tableView.footer endRefreshing];
    }
    
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
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, SCREEN_HEIGHT-_tableView.frame.origin.y)];
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
        UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
        view.hidden = NO;
    
    
}

-(void)dealloc
{
    [[ SDWebImageManager sharedManager] cancelAll];
}


#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    ispage = requestDic[@"ispage"];
    nextpage = requestDic[@"nextpage"];
    NSArray* commoditys = requestDic[@"commoditys"];
    
    NSString* remainTime = requestDic[@"remianTime"];
    if (remainTime) {
        _time.times = remainTime;
    }
    NSString* time = requestDic[@"time"];
    if (time) {
        _titleLabel.text = [NSString stringWithFormat:@"%@",time];
    }
    [_tableSource removeAllObjects];
    for (NSDictionary* dic in commoditys) {
        allMerModel* model = [[allMerModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_tableSource addObject:model];
    }
    [_tableView reloadData];
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        switch (_type) {
            case WXCommdityConvertType:
                _label.text = @"积分商城";
                break;
            case WXCommditySaleType:
                _label.text = @"限时抢购";
                break;
            case WXCommdityRecommendType:
                _label.text = @"每日推荐";
                break;
                
            default:
                break;
        }
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark - private

-(void)touchBtn:(UIButton*)sender
{
    
}

-(void)regitecell
{
    UINib* recommend = [UINib nibWithNibName:@"recommendTableViewCell" bundle:nil];
    [_tableView registerNib:recommend forCellReuseIdentifier:@"recommendcell"];
    UINib* integral = [UINib nibWithNibName:@"integralTableViewCell" bundle:nil];
    [_tableView registerNib:integral forCellReuseIdentifier:@"integralcell"];
    UINib* sale = [UINib nibWithNibName:@"saleTableViewCell" bundle:nil];
    [_tableView registerNib:sale forCellReuseIdentifier:@"salecell"];
    
    UINib* convert = [UINib nibWithNibName:@"convertTableViewCell" bundle:nil];
    [_tableView registerNib:convert forCellReuseIdentifier:@"convertcell"];
    
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
        case WXCommdityRecommendType:
            [identifier insertString:@"recommend" atIndex:0];
            break;
        case WXCommdityConvertType:
            [identifier insertString:@"convert" atIndex:0];
            break;
        case WXCommditySaleType:
            [identifier insertString:@"sale" atIndex:0];
            break;
        default:
            break;
    }
    
    rootTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.merModel = _tableSource[indexPath.row];
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
    credetialViewController* root = [[credetialViewController alloc]init];
    goodsDetailViewController* goods = [[goodsDetailViewController alloc]init];
    allMerModel* model = _tableSource[indexPath.row];
    switch (_type) {
            
        case WXCommdityConvertType:
            
            root.model = model;
            root.inteID = model.id;
            [self.navigationController pushViewController:root animated:YES];
            
            break;
            
        case WXCommdityRecommendType:
            
            goods.model = model;
            goods.commid = model.id;
            [self.navigationController pushViewController:goods animated:YES];
            
            break;
        
        case WXCommditySaleType:
            
            goods.model = model;
            goods.commid = model.id;
            [self.navigationController pushViewController:goods animated:YES];
            
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
