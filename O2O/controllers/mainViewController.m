//
//  mainViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "mainViewController.h"
#import "rootTableViewCell.h"
#import "categoryTableViewCell.h"
#import "UIColor+hexColor.h"
#import "mainTableViewCell.h"
#import "shopTableViewCell.h"
#import "moreCateViewController.h"
#import "allGoodsViewController.h"
#import "searchViewController.h"
#import "otherViewController.h"
#import "goodsDetailViewController.h"
#import "countdown.h"
#import "scrollPhotos.h"
#import "sweepViewController.h"
#import "adTableViewCell.h"

#import "zifenTableViewCell.h"

@interface mainViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    
    NSArray* names;
    countdown* _countdown;
    WXProcess* _process;
    NSMutableDictionary* _messageDic;
}

@property(nonatomic,strong)NSMutableArray* tableSource;
@property(nonatomic,strong)UIScrollView* headscrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray* headImages;
@property(nonatomic,strong)UIPageControl* pageControl;
@property(nonatomic,strong)scrollPhotos* headView;
@property(nonatomic,strong)UIView* footerView;
@property(nonatomic,strong)NSMutableArray* catrgorys;

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initnavigationBar];
    
    [self.view addSubview:self.tableView];
    
    [self registeCell];
    
    HTTPRequest* request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    _messageDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    [request requestWitUrl:MAIN_IF andArgument:dic andType:WXHTTPRequestGet];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [request requestWitUrl:MAIN_IF andArgument:_messageDic andType:WXHTTPRequestGet];
    }];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    [_headImages removeAllObjects];
    [_tableSource removeAllObjects];
    [self.headImages addObjectsFromArray:requestDic[@"pics"]];
    
    [self.tableSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.catrgorys,@"commoditys", nil]];
    
    [self.tableSource addObject:requestDic[@"flashSale"]];
    
    [self.tableSource addObject:requestDic[@"integralStore"]];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSMutableArray* commoditys = [[NSMutableArray alloc]init];
    NSDictionary* Guanggao = requestDic[@"Guanggao"];
    [commoditys addObject:Guanggao[@"gpicturl"]];
    [dic setObject:commoditys forKey:@"commoditys"];
    
    [self.tableSource addObject:dic];
    
    [self.tableSource addObject:requestDic[@"Recommend"]];
    
    [self reloadData];
    [_tableView.header endRefreshing];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {
        return [[_tableSource[4] objectForKey:@"commoditys"] count];
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString* identifier = [[NSMutableString alloc]initWithString:@"Cell"];
    
    switch (indexPath.section) {
        case 0:
            [identifier insertString:@"category" atIndex:0];
            break;
        case 1:
            [identifier insertString:@"shop" atIndex:0];
            break;
        case 2:
            [identifier insertString:@"shop" atIndex:0];
            break;
        case 3:
            [identifier insertString:@"ad" atIndex:0];
            break;
        case 4:
            [identifier insertString:@"main" atIndex:0];
            break;
        default:
            break;
    }
    
    rootTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.index = indexPath.section;
    cell.delegate = self;
    cell.messages = [_tableSource[indexPath.section] objectForKey:@"commoditys"];
    [cell addDelegate:self andAction:@selector(tapAction:)];
    
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
    if (indexPath.section < 4) {
        return;
    }
    
    NSArray* commoditys = [_tableSource[indexPath.section] objectForKey:@"commoditys"];
    NSDictionary* dic = commoditys[indexPath.row];
    
    allMerModel* model = [[allMerModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    
    goodsDetailViewController* goods = [[goodsDetailViewController alloc]init];
    goods.commid = model.id;
    goods.model = model;
    
    [self.navigationController pushViewController:goods animated:YES];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else if (section == 1 || section == 2 || section == 4)
    {
        return [self createheaderViewWithSection:section];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2 ||section == 4) {
        return 30;
    }else if(section == 3)
    {
        return 5;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section <2) {
        return 10;
    }else if (section == 3)
    {
        return 5;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 220;
    }else if (indexPath.section == 1 || indexPath.section == 2)
    {
        return 180;
    }else if (indexPath.section == 4)
    {
        return 100;
    }else if (indexPath.section == 3)
    {
        return 90;
    }
    return 0;
}

#pragma - mark - setter



#pragma mark - getter

-(NSMutableArray*)catrgorys
{
    if (_catrgorys == nil) {
        _catrgorys = [[NSMutableArray alloc]init];
        NSArray* nameArr = @[@"超市",@"百货",@"美食",@"电影",@"KTV",@"酒店",@"团购",@"更多分类"];
        NSArray* images = @[@"nav1",@"nav2",@"nav3",@"nav4",@"nav5",@"nav6",@"nav7",@"nav8"];
        
        for (int i = 0; i < nameArr.count; i++) {
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:nameArr[i],@"name",images[i],@"image", nil];
            [_catrgorys addObject:dic];
        }
        
    }
    
    return _catrgorys;
}

-(UIView*)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _footerView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
        UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        backView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:backView];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 2, SCREEN_WIDTH, 30)];
        [button setTitle:@"查看全部商品" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#F0547C"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(touchfooter:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E3E3E5"];
        [backView addSubview:line];
        
    }
    return _footerView;
}

-(UIView*)headView
{
    if (_headView == nil) {
        _headView = [[scrollPhotos alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, 150)];
        _headView.delegate = self;
        _headView.photos = _headImages;
    }
    return _headView;
}

-(NSMutableArray*)headImages
{
    if (_headImages == nil) {
        _headImages = [[NSMutableArray alloc]init];
    }
    return _headImages;
}

-(NSMutableArray*)tableSource
{
    if (_tableSource == nil) {
        _tableSource = [[NSMutableArray alloc]init];
    }
    return _tableSource;
}

#pragma mark - private

-(void)tapmore:(UIButton*)sender
{
    
    
    
    NSInteger num = sender.tag - 200;
    otherViewController* other = [[otherViewController alloc]init];
    
    switch (num) {
        case 3:
            other.type = WXCommdityRecommendType;
            break;
        case 2:
            other.type = WXCommdityConvertType;
            break;
        case 1:
            other.type = WXCommditySaleType;
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:other animated:YES];
    
    
}

-(void)searchBtn:(UIButton*)sender
{
    searchViewController* search = [[searchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

-(void)touchfooter:(UIButton*)sender
{
    allGoodsViewController* allgoods = [[allGoodsViewController alloc]init];
    allgoods.typeid = @"0";
    [self.navigationController pushViewController:allgoods animated:YES];
}

-(void)tapAction:(NSNumber*)number
{
    NSInteger num = [number integerValue];
    if (num == 17) {
        moreCateViewController* moreVC = [[moreCateViewController alloc]init];
        [self.navigationController pushViewController:moreVC animated:YES];
    }else
    {
        NSArray* nameArr = @[@"超市",@"百货",@"美食",@"电影",@"KTV",@"酒店",@"团购",@"更多分类"];
        allGoodsViewController* goodsVC = [[allGoodsViewController alloc]init];
        goodsVC.btnName = nameArr[num-10];
        goodsVC.typeid = [NSString stringWithFormat:@"%ld",num+1 - 10];
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}

-(UIView*)createheaderViewWithSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    
    UILabel* upline = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 1)];
    upline.backgroundColor = [UIColor colorWithHexString:@"#E3E3E5"];
    [view addSubview:upline];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
    switch (section) {
        case 1:
            label.text = @"限时秒杀";
            break;
        case 2:
            label.text = @"积分商城";
            break;
        case 4:
            label.text = @"推荐商品";
            break;
            
        default:
            break;
    }
    
    label.textColor = [UIColor colorWithHexString:@"#FF628C"];
    label.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:label];
    if (section == 1) {
        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 24, 20)];
        label1.text = @"还剩";
        label1.textColor = [UIColor colorWithHexString:@"#949494"];
        label1.font = [UIFont systemFontOfSize:12];
        [view addSubview:label1];
        
        if (_countdown ==nil) {
            _countdown = [[countdown alloc]initWithFrame:CGRectMake(115, 0, 70, 30)];
            NSDictionary* dic = _tableSource[section];
            NSString* time = dic[@"remianTime"];
            
            _countdown.times = time;
            
        }
        [view addSubview:_countdown];
        
    }
    UIButton* more = [UIButton buttonWithType:UIButtonTypeCustom];
    [more setFrame:CGRectMake(SCREEN_WIDTH - 50, 8, 40, 20)];
    [more setTitle:@"更多>>" forState:UIControlStateNormal];
    more.titleLabel.font = [UIFont systemFontOfSize:12];
    more.tag = section + 200;
    [more addTarget:self action:@selector(tapmore:) forControlEvents:UIControlEventTouchUpInside];
    [more setTitleColor:[UIColor colorWithHexString:@"#949494"] forState:UIControlStateNormal];
    [view addSubview:more];
    return view;
    
}

-(void)registeCell
{
    UINib* categorynib = [UINib nibWithNibName:@"categoryTableViewCell" bundle:nil];
    [_tableView registerNib:categorynib forCellReuseIdentifier:@"categoryCell"];
    
    UINib* mainnib = [UINib nibWithNibName:@"mainTableViewCell" bundle:nil];
    [_tableView registerNib:mainnib forCellReuseIdentifier:@"mainCell"];
    
    UINib* shopnib = [UINib nibWithNibName:@"shopTableViewCell" bundle:nil];
    [_tableView registerNib:shopnib forCellReuseIdentifier:@"shopCell"];
    
    UINib* advertisment = [UINib nibWithNibName:@"adTableViewCell" bundle:nil];
    [_tableView registerNib:advertisment forCellReuseIdentifier:@"adCell"];
    
    UINib* zifen = [UINib nibWithNibName:@"zifenTableViewCell" bundle:nil];
    [_tableView registerNib:zifen forCellReuseIdentifier:@"zifenCell"];
    
}

-(void)reloadData
{
    _countdown = nil;
    _headView = nil;
    _footerView = nil;
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = self.footerView;
    [_tableView reloadData];
    
}

-(void)sweepBtn:(UIButton*)sender
{
    sweepViewController* root = [[sweepViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
}

-(void)initnavigationBar
{
//    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(0, 0, 80, 38)];
////    [leftButton setBackgroundImage:[UIImage imageNamed:@"011.jpg"] forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    
    UIImageView* leftimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    leftimage.image = [UIImage imageNamed:@"logo"];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithCustomView:leftimage];
    
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton* rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton1 setBackgroundImage:[UIImage imageNamed:@"qrcode"] forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(sweepBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc]initWithCustomView:rightButton1];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 5, 170, 30)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"searchbar"]
                        forState:UIControlStateNormal];
    [rightBtn setTitle:@"   输入商品名称               " forState:UIControlStateNormal];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentJustified;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#949494"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    
    
}

@end
