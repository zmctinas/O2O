//
//  categoryViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "categoryViewController.h"
#import "cateCollectionViewCell.h"
#import "searchViewController.h"
#import "cateModel.h"
#import "collModel.h"
#import "goodsDetailViewController.h"
#import "UIColor+hexColor.h"

@interface categoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,searchprotocolDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    NSMutableArray* _cateSource;
    WXProcess* _process;
    HTTPRequest* leftReq;
    HTTPRequest* rightReq;
    NSMutableDictionary* messageDic;
    NSString* ispage;
    NSString* nextpage;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(strong,nonatomic)UILabel* label;

@property(nonatomic,strong)UIImageView* headView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)searchBtn:(UIButton *)sender;

- (IBAction)changeBtn:(UIButton *)sender;

@end

@implementation categoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分类";
    
    _tableSource = [[NSMutableArray alloc]init];
    _cateSource = [[NSMutableArray alloc]init];
    
    self.navigationItem.titleView = self.label;
    
//    NSArray* arr = @[@"女士服装",@"内衣饰品",@"男士服装",@"运动户外",@"鞋/箱包",@"美妆护肤",@"手机数码",@"母婴用品",@"食品烟酒",@"小家电",@"珠宝配饰",@"名表眼睛",@"家纺家饰",@"家居用品"];
//    [_cateSource addObjectsFromArray:arr];
    
    
    
    [self registercell];
    
    leftReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    [leftReq requestWitUrl:LEFTCATE_IF andArgument:nil andType:WXHTTPRequestGet];
    
    
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (ispage.integerValue == 1) {
            rightReq.tag = 2;
            [messageDic setObject:nextpage forKey:@"page"];
            [rightReq requestWitUrl:RIGHTCATE_IF andArgument:messageDic andType:WXHTTPRequestGet];
        }else
        {
            [self.collectionView.footer endRefreshing];
        }
        
        
    }];
    
//    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    
//    [footer setTitle:@"正在努力加载..." forState:MJRefreshStateRefreshing];
//    self.collectionView.footer = footer;
    // 默认先隐藏footer
//    self.collectionView.footer.hidden = YES;
    
    
    // Do any additional setup after loading the view.
}

-(void)loadMoreData
{
    if (ispage.integerValue == 1) {
        rightReq.tag = 2;
        [messageDic setObject:nextpage forKey:@"page"];
        [rightReq requestWitUrl:RIGHTCATE_IF andArgument:messageDic andType:WXHTTPRequestGet];
    }else
    {
        [self.collectionView.footer endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    ispage = requestDic[@"ispage"];
    nextpage = requestDic[@"nextpage"];
    if (request == leftReq) {
        NSArray* categorys = requestDic[@"categorys"];
        [_cateSource removeAllObjects];
        for (NSDictionary* dic in categorys) {
            cateModel* model = [[cateModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_cateSource addObject:model];
        }
        [self createscrollview];
        if (_cateSource.count>0) {
            UIButton* btn = (UIButton*)[_scrollView viewWithTag:10];
            [self touchBtn:btn];
        }
        
    }else if (request == rightReq)
    {
        NSArray* goods = requestDic[@"goods"];
        if (request.tag == 1 ) {
            [_tableSource removeAllObjects];
        }
        for (NSDictionary* dic in goods) {
            allMerModel* model = [[allMerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        NSArray* guanggao = requestDic[@"guanggao"];
        NSDictionary* guanggaoDic = guanggao[0];
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,guanggaoDic[@"picurl"]];
        [self.headView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
        _headView.tag = [guanggaoDic[@"id"] integerValue];
        [_collectionView reloadData];
        
        if (_tableSource.count == 0) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无商品，敬请期待" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView.footer endRefreshing];
        
    }
    
}

#pragma mark - private

-(void)createscrollview
{
    for (int i = 0; i< _cateSource.count; i++) {
        cateModel* model = _cateSource[i];
        UIButton* btn = [UIButton buttonWithType: UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, i*40, 100, 40)];
        [btn setTitle:model.classname forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setBackgroundImage:[UIImage imageNamed:@"input"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"menubg"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i+ 10;
        [_scrollView addSubview:btn];
    }
    
    _scrollView.contentSize = CGSizeMake(0, 40*_cateSource.count);
    
}

-(void)registercell
{
    UINib* cate = [UINib nibWithNibName:@"cateCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cate forCellWithReuseIdentifier:@"catecell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
}

-(void)touchBtn:(UIButton*)sender
{
    sender.selected = YES;
    
    NSArray* arr = _scrollView.subviews;
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag != sender.tag) {
                btn.selected = NO;
            }
        }
    }
    
    cateModel* model = _cateSource[sender.tag-10];
    rightReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    messageDic = [[NSMutableDictionary alloc]initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:model.id,@"gid",@"1",@"page", nil]];
    
    [rightReq requestWitUrl:RIGHTCATE_IF andArgument:messageDic andType:WXHTTPRequestGet];
    
}

-(void)createBtn
{
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"分类";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


-(UIImageView*)headView
{
    if (_headView == nil) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 190, 60)];
        _headView.image = [UIImage imageNamed:@"loding2"];
    }
    return _headView;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _tableSource.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cateCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"catecell" forIndexPath:indexPath];
    
    
        cell.model = _tableSource[indexPath.row];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    allMerModel* model = _tableSource[indexPath.row];
    goodsDetailViewController* root = [[goodsDetailViewController alloc]init];
    root.commid = model.id;
    root.model = model;
    [self.navigationController pushViewController:root animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    [reusable addSubview:self.headView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 100, 20)];
    label.text = @"为您推荐";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#414141"];
    [reusable addSubview:label];
    
    return reusable;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(_collectionView.frame.size.width, 90);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 0, 2);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(93, 100);
}

#pragma mark - searchprotocolDelegate

-(void)getSearchMessage:(NSString *)message
{
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSIndexPath* indexPath = [_collectionView indexPathForItemAtPoint:CGPointMake(45+_collectionView.contentOffset.x, 205+_collectionView.contentOffset.y)];
//    NSLog(@"%ld",indexPath.row);
//    
//}

#pragma mark - xib

- (IBAction)searchBtn:(UIButton *)sender {
    
    searchViewController* root = [[searchViewController alloc]init];
    root.delegate = self;
    [self.navigationController pushViewController:root animated:YES];
    
}

- (IBAction)changeBtn:(UIButton *)sender {
}
@end
