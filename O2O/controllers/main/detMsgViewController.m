//
//  detMsgViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/28.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "detMsgViewController.h"
#import "commentTableViewCell.h"
#import "detailModel.h"
#import "commentModel.h"
#import "UIColor+hexColor.h"
#import "commentStar.h"
#import "photoalbumViewController.h"

@interface detMsgViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* commentReq;
    NSString* sum;
    NSString* commentNum;
    NSString* ispage;
    NSString* nextpage;
    NSMutableDictionary* _messageDic;
}

@property(strong,nonatomic)UILabel* label;

@property(strong,nonatomic)UIView* headerView;

@property(strong,nonatomic)UITableView* tableView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

- (IBAction)navBtn:(UIButton *)sender;

@end

@implementation detMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableSource = [[NSMutableArray alloc]init];
    
    [self initscrollView];
    
    [self registercell];
    
    self.navigationItem.titleView = self.label;
    
    commentReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_comid,@"gid", nil];
    _messageDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [commentReq requestWitUrl:COMMENT_IF andArgument:dic andType:WXHTTPRequestGet];
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:10+_offset];
    [self navBtn:btn];
    
    [_oneBtn setTitleColor:[UIColor colorWithHexString:@"#FE437E"] forState:UIControlStateSelected];
    [_twoBtn setTitleColor:[UIColor colorWithHexString:@"#FE437E"] forState:UIControlStateSelected];
    [_threeBtn setTitleColor:[UIColor colorWithHexString:@"#FE437E"] forState:UIControlStateSelected];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.automaticallyRefresh = NO;
    [footer setTitle:@"已经加载到最后一页了" forState:MJRefreshStateNoMoreData];
    _tableView.footer = footer;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_messageDic setObject:@"1" forKey:@"page"];
        commentReq.tag = 1;
        [commentReq requestWitUrl:COMMENT_IF andArgument:_messageDic andType:WXHTTPRequestGet];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadMoreData
{
    if ([ispage isEqualToString:@"1"]) {
        [_messageDic setObject:nextpage forKey:@"page"];
        commentReq.tag = 2;
        [commentReq requestWitUrl:COMMENT_IF andArgument:_messageDic andType:WXHTTPRequestGet];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    sum = requestDic[@"sum"];
    commentNum = requestDic[@"commentNum"];
    NSArray* comments = requestDic[@"comments"];
    if (request.tag == 1) {
        [_tableSource removeAllObjects];
    }
    for (NSDictionary* dic in comments) {
        commentModel* model = [[commentModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_tableSource addObject:model];
    }
    _tableView.tableHeaderView = self.headerView;
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    [_tableView reloadData];
    
}

#pragma mark - getter

-(UIView*)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,40)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.layer.borderColor = [UIColor colorWithHexString:@"#F3F3F3"].CGColor;
        _headerView.layer.borderWidth = 0.5;
        commentStar* star = [[commentStar alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
        star.numofStar = [sum integerValue];
        star.selectingenabled = NO;
        [_headerView addSubview:star];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(100, 7, 60, 20)];
        label.text = [NSString stringWithFormat:@"%@.0分",sum];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHexString:@"#F16400"];
        [_headerView addSubview:label];
        UILabel* commenLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 7, 90, 20)];
        commenLabel.text =[NSString stringWithFormat:@"%@人评价>",commentNum];
        commenLabel.textColor = [UIColor colorWithHexString:@"#FF3F7A"];
        commenLabel.font = [UIFont systemFontOfSize:15];
        commenLabel.textAlignment = NSTextAlignmentRight;
        [_headerView addSubview:commenLabel];
    }
    return _headerView;
}

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.text = @"产品详情";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:17];
    }
    return _label;
}

-(UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(2*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - private

-(void)touchImage:(NSDictionary*)message
{
    photoalbumViewController* photo = [[photoalbumViewController alloc]init];
    photo.imageName = message[@"imageName"];
    photo.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    photo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:photo animated:YES completion:^{
        
    }];

}

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"commentTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"commentcell"];
}

-(void)initscrollView
{
    
    NSArray* arr = @[COMDETAIL_WEB,SHANGJIA_WEB];
    
    for (int i= 0 ; i<2; i++) {
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        NSString* urlStr = [NSString stringWithFormat:arr[i],_comid];
        NSURL* url = [NSURL URLWithString:urlStr];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];

        [_scrollView addSubview:webView];
    }
    
    [_scrollView addSubview:self.tableView];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*3, 0);
    
}

-(void)moveLabel:(NSInteger)index
{
    __block CGRect lineFrame  = _lineLabel.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        _lineLeft.constant = index* SCREEN_WIDTH /3;
//        lineFrame.origin.x = index* SCREEN_WIDTH /3;
        _lineLabel.frame = lineFrame;
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"commentcell" forIndexPath:indexPath];
    
    commentModel* model = _tableSource[indexPath.row];
    
    cell.comModel = model;
    
    [cell addDelegate:self andAction:@selector(touchImage:)];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentModel* model = _tableSource[indexPath.row];
    NSInteger height;
    CGRect rect;
    rect = [model.commentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    height = rect.size.height - 20 + 60;
    if (model.picarr.count > 0) {
        height += 90;
    }
    
    
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 320, 30)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [UIColor colorWithHexString:@"#F3F3F3"].CGColor;
    view.layer.borderWidth = 0.5;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
    label.text = @"用户评论";
    [view addSubview:label];
    [backView addSubview:view];
    return backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        NSInteger num = scrollView.contentOffset.x/_scrollView.frame.size.width;
        
        UIButton* btn = (UIButton*)[self.view viewWithTag:num + 10];
        [self navBtn:btn];
    }
}

#pragma mark - xib

- (IBAction)navBtn:(UIButton *)sender {
    
    sender.selected = YES;
    
    NSArray* arr = [self.headBackView subviews];
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (sender.tag != btn.tag) {
                btn.selected = NO;
            }
        }
    }
    
    NSInteger num = sender.tag - 10;
    
    [self moveLabel:num];
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*num, 0) animated:YES];
    
}
@end
