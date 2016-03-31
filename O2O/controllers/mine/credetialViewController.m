//
//  credetialViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "credetialViewController.h"
#import "creHeadTableViewCell.h"
#import "credetialViewController.h"
#import "productTableViewCell.h"
#import "detailModel.h"


@interface credetialViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* detailReq;
    NSUserDefaults* defaults;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(strong,nonatomic)UILabel* label;

@end

@implementation credetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableSource = [[NSMutableArray alloc]init];
    
    self.navigationItem.titleView = self.label;
    
    [self registercell];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
   [self request];
    
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

-(void)request
{
    NSString* uid = [defaults objectForKey:@"uid"];
    
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_model.id,@"inteid", nil];
    
    detailReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    [detailReq requestWitUrl:INTEXCHANGE_IF andArgument:dic andType:WXHTTPRequestGet];
}

#pragma mark - changeAddressDelegate

-(void)changeAddress
{
    [self request];
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSLog(@"%@",requestDic);
    NSString* integral = requestDic[@"integral"];
    [defaults setObject:integral forKey:@"integral"];
    [defaults synchronize];
    
    [_tableSource removeAllObjects];
    NSArray* inteImgs = requestDic[@"inteImgs"];
    NSArray* productmessage = requestDic[@"productmessage"];
    NSDictionary* inteImgsDic = inteImgs[0];
    NSArray* picd = inteImgsDic[@"picd"];
    allMerModel* model1 = [[allMerModel alloc]init];
    model1.integral = _model.integral;
    model1.id = _model.id;
    NSLog(@"%ld",[inteImgsDic[@"num"] integerValue]);
    _model.num = [inteImgsDic[@"num"] integerValue];
    model1.num = [inteImgsDic[@"num"] integerValue];
    for (NSDictionary* dic in picd) {
        [model1.commoditys addObject:dic[@"pirurl"]];
    }
    NSDictionary* dic = productmessage[0];
    [model1.commoditys addObject:dic[@"picurl_b"]];
    _model.num = [dic[@"num"] integerValue];
    
    [_tableSource addObject:model1];
    
    [_tableSource addObject:_model];
    
//    for (NSDictionary* dic in productmessage) {
    if (productmessage.count >0) {
        NSDictionary* dic = productmessage[0];
        allMerModel* model = [[allMerModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        model.type = WXGOODSProductMessage;
        [_tableSource addObject:model];
    }
    
//    }
    [_tableview reloadData];
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.text = @"积分兑换详情";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:17];
    }
    return _label;
}

#pragma mark - private

-(void)registercell
{
    UINib* header = [UINib nibWithNibName:@"creHeadTableViewCell" bundle:nil];
    [_tableview registerNib:header forCellReuseIdentifier:@"headercell"];
    
    UINib* detail = [UINib nibWithNibName:@"credetTableViewCell" bundle:nil];
    [_tableview registerNib:detail forCellReuseIdentifier:@"detailcell"];
    
    UINib* product = [UINib nibWithNibName:@"productTableViewCell" bundle:nil];
    [_tableview registerNib:product forCellReuseIdentifier:@"productcell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _tableSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString* identifier = [[NSMutableString alloc]initWithString:@"cell"];
    allMerModel* model = _tableSource[indexPath.section];
    switch (model.type) {
        case WXGOODSProductMessage:
            [identifier insertString:@"product" atIndex:0];
            break;
            
        default:
            
            if (indexPath.section == 0) {
                [identifier insertString:@"header" atIndex:0];
            }else
            {
                [identifier insertString:@"detail" atIndex:0];
            }
            
            break;
    }
    
    rootTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.merModel = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 0 ;
    CGRect rect;
    allMerModel* model = _tableSource[indexPath.section];
    if (indexPath.section == 0) {
        return 240;
    }else if (indexPath.section == 1)
    {
//        rect = [model.descriptions boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
        return 100;
    }else
    {
        rect = [model.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
        height = rect.size.height - 21 + 44;
        return height;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
    
    [view addSubview:label];
    
    if (section == 0) {
        return nil;
    }else if (section == 1)
    {
        allMerModel* model = _tableSource[section];
        label.text = model.comName;
    }else
    {
        allMerModel* model = _tableSource[section];
        switch (model.type) {
            case WXGoodsComment:
                label.text = @"评价";
                break;
            case WXGoodsConsumeReminder:
                label.text = @"消费提示";
                break;
            case WXGOODSMerchantMessage:
                label.text = @"商品信息";
                break;
            case WXGOODSProductMessage:
                label.text = @"产品信息";
                break;
            case WXGoodsRecommend:
                label.text = @"为您推荐";
                break;
            default:
                
                break;
        }
        
    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

@end
