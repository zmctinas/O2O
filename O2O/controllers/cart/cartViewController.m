//
//  cartViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "cartViewController.h"
#import "AppDelegate.h"
#import "cateTableViewCell.h"
#import "gopayViewController.h"
#import "carHeadView.h"
#import "carComModel.h"
#import "carMerModel.h"
#import "cartOrderViewController.h"

@interface cartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* _tableSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (weak, nonatomic) IBOutlet UIView *jiesuanView;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property(strong,nonatomic)UIBarButtonItem* rightItem;


- (IBAction)selectAction:(UIButton *)sender;

- (IBAction)payaction:(UIButton *)sender;

- (IBAction)goshop:(UIButton *)sender;

@end

@implementation cartViewController
{
    NSUserDefaults* defaults;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    self.automaticallyAdjustsScrollViewInsets = NO;
    defaults = [NSUserDefaults standardUserDefaults];
    
    
    _tableSource = [NSMutableArray array];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registercell];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    [FrameSize MLBFrameSize:self.view];
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
//    [self addnotification];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
    
//    self.navigationItem.hidesBackButton = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headbg"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName: [UIColor whiteColor],
//       NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
    
    [self requestData];
    self.selectBtn.selected = NO;
    
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 60, 30)];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}

#pragma mark - private

-(void)addnotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectCommitity:) name:@"WXSelectCommitity" object:nil];
}

-(void)selectCommitity:(NSNotification*)usinfo
{
    
}

-(void)rightAction:(UIButton*)sender
{
    NSMutableString* array_id = [NSMutableString string];
    for (carMerModel* shopModel in _tableSource) {
        for (carComModel* model in shopModel.shopArr) {
            if (model.isSelect) {
                if (array_id.length>0) {
                    [array_id appendString:@","];
                }
                [array_id appendString:model.carid];;
            }
        }
    }
    NSString* uid = [defaults objectForKey:@"uid"];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",@"del",@"act",array_id,@"array_id", nil];
    [HTTPRequest requestWitUrl:EXITSHOPCAR_IF andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
        if ([requestDic[@"message"]isEqualToString:@"1"]) {
            [WXalertView alertWithMessage:@"删除成功" andDelegate:self];
            [self requestData];
        }else
        {
            [WXalertView alertWithMessage:@"删除失败" andDelegate:self];
        }
    } Falsed:^(NSError *error) {
        [WXalertView alertWithMessage:@"删除失败" andDelegate:self];
    }];
}

-(void)hascommidity
{
    if (_tableSource.count > 0) {
        self.emptyView.hidden = YES;
        self.jiesuanView.hidden = NO;
    }else
    {
        self.jiesuanView.hidden = YES;
        self.emptyView.hidden = NO;
    }

}

-(void)requestData
{
    NSString* uid = [defaults objectForKey:@"uid"];
    
    [HTTPRequest requestWitUrl:SHOPCAR_IF andArgument:[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil] andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
        NSString* message = requestDic[@"message"];
        if ([message isEqualToString:@"1"]) {
            [_tableSource removeAllObjects];
            NSArray* shopcart = requestDic[@"shopcart"];
            for (NSDictionary* shopDic in shopcart) {
                carMerModel* shopModel = [[carMerModel alloc]init];
                [shopModel setValuesForKeysWithDictionary:shopDic];
                NSArray* cart = shopDic[@"cart"];
                for (NSDictionary* dic in cart) {
                    carComModel* model = [[carComModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [shopModel.shopArr addObject:model];
                }
                [_tableSource addObject:shopModel];
            }
            [_tableView reloadData];
        }
        [self hascommidity];
    } Falsed:^(NSError *error) {
        
    }];
    
}

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"cateTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"catecell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    carMerModel* model = _tableSource[section];
    return model.shopArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"catecell" forIndexPath:indexPath];
    
    carMerModel* shopModel = _tableSource[indexPath.section];
    cell.carModel = shopModel.shopArr[indexPath.row];
    
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
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90*[FrameSize proportionWidth];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    carHeadView* carView = [[NSBundle mainBundle]loadNibNamed:@"carHeadView" owner:self options:nil][0];
    
    carMerModel* model = _tableSource[section];
    carView.titleLabel.text = model.title;
    return carView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*[FrameSize proportionWidth];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - xib

- (IBAction)selectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    for (carMerModel* shopModel in _tableSource) {
        for (carComModel* model in shopModel.shopArr) {
            model.isSelect = sender.selected;
        }
    }
    [_tableView reloadData];
}

- (IBAction)payaction:(UIButton *)sender {
    
    NSMutableString* cid = [NSMutableString string];
    for (carMerModel* shopModel in _tableSource) {
        for (carComModel* model in shopModel.shopArr) {
            if (model.isSelect) {
                if (cid.length>0) {
                    [cid appendString:@","];
                }
                [cid appendString:model.carid];;
            }
        }
    }
    if (!cid.length>0) {
        [WXalertView alertWithMessage:@"请选择要结算的商品" andDelegate:self];
        return;
    }
    
    cartOrderViewController* gopayVC = [[cartOrderViewController alloc]init];
    gopayVC.cid = cid;
    [self.navigationController pushViewController:gopayVC animated:YES];
    
}

- (IBAction)goshop:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    for (int i = 0; i<5; i++) {
        UIButton* btn = (UIButton*)[self.tabBarController.view viewWithTag:10+i];
        if (i == 0) {
            btn.selected = YES;
        }else
        {
            btn.selected = NO;
        }
        
    }
    
    self.tabBarController.selectedIndex = 0;
    
}
@end
