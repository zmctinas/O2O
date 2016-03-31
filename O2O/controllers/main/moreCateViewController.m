//
//  moreCateViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "moreCateViewController.h"
#import "moreCateCollectionViewCell.h"
#import "UIColor+hexColor.h"
#import "categoryModel.h"
#import "allGoodsViewController.h"

@interface moreCateViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HTTPRequestDataDelegate>
{
    NSMutableArray* _collectionSource;
    HTTPRequest* cateReq;
    WXProcess* _process;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(strong,nonatomic)UILabel* label;




@end

@implementation moreCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    _collectionSource = [[NSMutableArray alloc]init];
    
    
    UINib* nib = [UINib nibWithNibName:@"moreCateCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"cateCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cateheader"];
    
    cateReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    [cateReq requestWitUrl:GOODMORE_IF andArgument:nil andType:WXHTTPRequestGet];
    _process = [[WXProcess alloc]init];
    [_process start];
    
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

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.text = @"更多分类";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:17];
    }
    return _label;
}

-(void)taouchAll:(UIButton*)sender
{
    allGoodsViewController* root = [[allGoodsViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSArray* categorys = requestDic[@"categorys"];
    for (NSDictionary* dic in categorys) {
        categoryModel* model = [[categoryModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        NSArray* next = dic[@"next"];
        for (NSDictionary* nextDic in next) {
            categoryModel* nextmodel = [[categoryModel alloc]init];
            [nextmodel setValuesForKeysWithDictionary:nextDic];
            [model.cateArr addObject:nextmodel];
        }
        [_collectionSource addObject:model];
    }
    [_collectionView reloadData];
    [_process stop];
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    categoryModel* model = [[_collectionSource[indexPath.section] cateArr] objectAtIndex:indexPath.row];
    allGoodsViewController* root = [[allGoodsViewController alloc]init];
    root.typeid = model.id;
    root.btnName = model.classname;
    [self.navigationController pushViewController:root animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 40);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(_collectionView.frame.size.width, 80);
    }
    return CGSizeMake(300, 30);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _collectionSource.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_collectionSource[section] cateArr] count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    moreCateCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cateCell" forIndexPath:indexPath];
   
    categoryModel* model = [[_collectionSource[indexPath.section] cateArr] objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.classname;
    cell.nameLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cateheader" forIndexPath:indexPath];
    
    NSArray* arr = [reusable subviews];
    for (UIView* view in arr) {
        [view removeFromSuperview];
    }
    
    UIView* view ;
    if (indexPath.section == 0) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 80)];
        
        UIButton* nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameBtn setFrame:CGRectMake(0, 10, _collectionView.frame.size.width, 30)];
        [nameBtn setBackgroundImage:[UIImage imageNamed:@"input"] forState:UIControlStateNormal];
        [nameBtn setTitle:@"全部分类" forState:UIControlStateNormal];
        [nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nameBtn addTarget:self action:@selector(taouchAll:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:nameBtn];
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 55, 15, 15)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu%ld",indexPath.section + 1]];
        [view addSubview:imageView];
        
        UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 62.5, SCREEN_WIDTH - 90, 1)];
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [view addSubview:lineLabel];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(25, 55, 60, 15)];
        categoryModel* model = _collectionSource[indexPath.section];
        label.text = model.classname;
        label.adjustsFontSizeToFitWidth = YES;
        [view addSubview:label];
        
    }else
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 25)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 5, 15, 15)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu%ld",indexPath.section + 1]];
        [view addSubview:imageView];
        
        UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 12.5, SCREEN_WIDTH - 90, 1)];
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [view addSubview:lineLabel];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, 100, 15)];
        categoryModel* model = _collectionSource[indexPath.section];
        label.text = model.classname;
        [view addSubview:label];
    }
    
    [reusable addSubview:view];
    
    return reusable;
}

@end
