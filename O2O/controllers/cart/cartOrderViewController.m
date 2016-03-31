//
//  cartOrderViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/9/8.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "cartOrderViewController.h"
#import "carMerModel.h"
#import "carOrderTableViewCell.h"
#import "goodsViewController.h"
#import "gopayViewController.h"
#import "youhuiBottom.h"

@interface cartOrderViewController ()<UITableViewDataSource,UITableViewDelegate,bottomprotrol>
{
    NSMutableArray* _tableSource;
    NSUserDefaults* defaults;
    NSString* aid;
    NSMutableArray* dateArr;
    youhuiModel* selectModel;
    CGFloat sum;
    NSMutableDictionary* messageDic;
}

@property(strong,nonatomic)UIView* footerView;
@property(strong,nonatomic) IBOutlet UIButton* youhuiBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (strong, nonatomic) IBOutlet UIView *conView;

- (IBAction)youhuiBtn:(UIButton *)sender;

- (IBAction)addressBtn:(UIButton *)sender;
- (IBAction)updataBtn:(UIButton *)sender;

@end

@implementation cartOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"生成订单";
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"#FF658E"];
    
    dateArr = [NSMutableArray array];
    
    messageDic = [NSMutableDictionary dictionary];
    defaults = [NSUserDefaults standardUserDefaults];
    _tableSource = [NSMutableArray array];
    
    [FrameSize MLBFrameSize:self.view];
    
//    [self.backScrollView addSubview:self.conView];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.backScrollView setContentSize:CGSizeMake(0, self.conView.frame.size.height)];
    
    
    
    [self registercell];
    
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
    
    [self requestData];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}

#pragma mark - getter

//-(UIButton*)youhuiBtn
//{
//    if (_youhuiBtn == nil) {
//        
//        _youhuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_youhuiBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        [_youhuiBtn setTitle:@"点击选择优惠券" forState:UIControlStateNormal];
//        [_youhuiBtn setTitleColor:[UIColor colorWithHexString:@"#FF658E"] forState:UIControlStateNormal];
//        [_youhuiBtn setBackgroundImage:[UIImage imageNamed:@"input"] forState:UIControlStateNormal];
//        _youhuiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_youhuiBtn addTarget:self action:@selector(couponBtn:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//    }
//    return _youhuiBtn;
//}

#pragma mark - private

-(void)couponBtn:(UIButton*)sender
{
    [self havecoupon];
}

-(void)havecoupon
{
    if (dateArr.count>0) {
        
        youhuiBottom* bottom = [[youhuiBottom alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:bottom];
        bottom.delegate = self;
        bottom.tableSource = dateArr;
        [bottom show];
        
    }else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无可用优惠券" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)sendMessage:(youhuiModel *)model
{
    selectModel = model;
    [_youhuiBtn setTitle:[NSString stringWithFormat:@"%@     金额%@元",model.title,model.money] forState:UIControlStateNormal];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",sum - selectModel.money.floatValue];
    
}

-(void)requestData
{
    
    NSString* uid = [defaults objectForKey:@"uid"];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_cid,@"cid", nil];
    
    [HTTPRequest requestWitUrl:FORPAY_IF andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
        if ([requestDic[@"message"]isEqualToString:@"1"]) {
            
            if ([requestDic[@"address"] count]>0) {
                NSArray* address = requestDic[@"address"];
                
                [self createAddress:address[0]];
            }else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无默认邮寄地址" delegate:self cancelButtonTitle:@"立即前往" otherButtonTitles:@"稍后再去", nil];
                alert.tag = 666;
                [alert show];
            }
            
            
            
            
            [_tableSource removeAllObjects];
            
            NSArray* order = requestDic[@"order"];
            
            NSArray* coupon = requestDic[@"coupon"];
            
            [dateArr removeAllObjects];
            for (NSDictionary* dic  in coupon) {
                youhuiModel* model = [[youhuiModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [dateArr addObject:model];
            }
            
            for (NSDictionary* shopDic in order) {
                carMerModel* shopModel = [[carMerModel alloc]init];
                [shopModel setValuesForKeysWithDictionary:shopDic];
                NSArray* coupon = shopDic[@"coupon"];
                for (NSDictionary* dic  in coupon) {
                    youhuiModel* model = [[youhuiModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [dateArr addObject:model];
                }
                NSArray* goods = shopDic[@"goods"];
                for (NSDictionary* dic in goods) {
                    carComModel* model = [[carComModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [shopModel.shopArr addObject:model];
                }
                [_tableSource addObject:shopModel];
            }
            [_tableView reloadData];
            [self getTotalPrice];
        }
    } Falsed:^(NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0&&alertView.tag == 666) {
        goodsViewController* root = [[goodsViewController alloc]init];
        [self.navigationController pushViewController:root animated:YES];
    }
}

-(void)getTotalPrice
{
    CGFloat totalPrice = 0.0;
    for (carMerModel* model  in _tableSource) {
        totalPrice += model.odertotprice.floatValue;
    }
    sum = totalPrice;
    if (selectModel == nil) {
        _totalPriceLabel.text = [NSString stringWithFormat:@"%0.2f",totalPrice];
    }else
    {
        _totalPriceLabel.text = [NSString stringWithFormat:@"%0.2f",totalPrice - selectModel.money.floatValue];
    }
    
}

-(void)createAddress:(NSDictionary*)dic
{
    _nameLabel.text = dic[@"rec_name"];
    _mobileLabel.text = dic[@"phone"];
    _descriptionLabel.text = dic[@"address"];
    aid = dic[@"id"];
}

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"carOrderTableViewCell" bundle:nil];
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
    carOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"catecell" forIndexPath:indexPath];
    
    carMerModel* shopModel = _tableSource[indexPath.section];
    carComModel* model = shopModel.shopArr[indexPath.row];
    cell.carModel = model;
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    carMerModel* model = _tableSource[section];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 20)];
    label.text = model.title;
    label.textColor = [UIColor colorWithHexString:@"#343536"];
    [view addSubview:label];
    
    UILabel* postPrice = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 5, 110, 20)];
    postPrice.text = [NSString stringWithFormat:@"邮费: ￥%@",model.postprice];
    postPrice.textColor = [UIColor colorWithHexString:@"#323232"];
    postPrice.textAlignment = NSTextAlignmentRight;
    [view addSubview:postPrice];
    
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    carMerModel* model = _tableSource[section];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    view.backgroundColor = [UIColor yellowColor];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 20)];
    label.text = @"总价";
    [view addSubview:label];
    
    UILabel* price = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 5, 70, 20)];
    price.text = [NSString stringWithFormat:@"￥%@",model.odertotprice];
    price.textAlignment = NSTextAlignmentRight;
    [view addSubview:price];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90*[FrameSize proportionWidth];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (IBAction)youhuiBtn:(UIButton *)sender {
    
    [self havecoupon];
}

- (IBAction)addressBtn:(UIButton *)sender {
    
    goodsViewController* root = [[goodsViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
}

- (IBAction)updataBtn:(UIButton *)sender {
    
    if (aid == nil) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择邮寄地址" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSMutableArray* comMessages = [NSMutableArray array];
    for (carMerModel* shopModel in _tableSource) {
        NSArray* shopArr = shopModel.shopArr;
        for (carComModel* model in shopArr) {
            
            [comMessages addObject:@{@"gid":model.gid,@"cid":model.cid,@"shopid":model.commid}];
            
        }
    }
    
    NSString* uid = [defaults objectForKey:@"uid"];
    NSData *data=  [NSJSONSerialization dataWithJSONObject:comMessages options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",aid,@"aid",jsonStr,@"product", nil];
    [messageDic addEntriesFromDictionary:dic];
    if (selectModel != nil) {
        [messageDic setObject:selectModel.password forKey:@"coupon_pwd"];
    }
    
    NSLog(@"%@",messageDic);
    [HTTPRequest requestWitUrl:FORDINGDAN_IF andArgument:messageDic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
        if ([requestDic[@"message"] isEqualToString:@"1"]) {
            gopayViewController* gopay = [[gopayViewController alloc]init];
            gopay.ordernum = requestDic[@"totordernum"];
            gopay.totalPrice = _totalPriceLabel.text;
            gopay.yueMoney = requestDic[@"money"];
            [self.navigationController pushViewController:gopay animated:YES];
        }
    } Falsed:^(NSError *error) {
        
    }];
}
@end
