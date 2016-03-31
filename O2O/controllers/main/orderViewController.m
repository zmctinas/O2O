//
//  orderViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/12.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "orderViewController.h"
#import "gopayViewController.h"
#import "goodsViewController.h"
#import "youhuiBottom.h"
#import "youhuiModel.h"
#import "carMerModel.h"
#import "carOrderTableViewCell.h"

@interface orderViewController ()<HTTPRequestDataDelegate,bottomprotrol,UIAlertViewDelegate>
{
    HTTPRequest* orderReq;
    NSUserDefaults* defaults;
    HTTPRequest* gopayReq;
    NSMutableDictionary* gopayDic;
    HTTPRequest* useReq;
    float sum;
    NSMutableArray* _tableSource;
    youhuiModel* selectModel;
    float totalPrice;
    NSMutableArray* dateArr;
    NSString* aid;
    NSDictionary* jsonDic;
    
}

@property(strong,nonatomic)UILabel* label;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
- (IBAction)youhuiBtn:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *conView;


- (IBAction)addressBtn:(UIButton *)sender;

- (IBAction)gopayBtn:(UIButton *)sender;

@end

@implementation orderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    gopayDic = [[NSMutableDictionary alloc]init];
    _tableSource = [NSMutableArray array];
    
    defaults = [NSUserDefaults standardUserDefaults];
//    NSString* uid = [defaults objectForKey:@"uid"];
    
    useReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    orderReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    _nickNameLabel.adjustsFontSizeToFitWidth = YES;
    
    [self registercell];
    
    [FrameSize MLBFrameSize:self.view];
    
//    [self.backScrollView addSubview:self.conView];
    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    [self.backScrollView setContentSize:CGSizeMake(0, self.conView.frame.size.height+100)];
//    self.conView.userInteractionEnabled = YES;
//    self.backScrollView.userInteractionEnabled = YES;
    
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
    NSString* uid = [defaults objectForKey:@"uid"];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_gid,@"gid",_messageDic[@"num"],@"num",_jsonStr,@"json", nil];
    [orderReq requestWitUrl:GOBUY_IF andArgument:dic andType:WXHTTPRequestGet];
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

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"carOrderTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"catecell"];
}

-(void)getTotalPrice
{
    CGFloat total = 0.0;
    for (carMerModel* model  in _tableSource) {
        total += model.odertotprice.floatValue;
    }
    sum = total;
    if (selectModel == nil) {
        _zongjiaLabel.text = [NSString stringWithFormat:@"%0.2f",total];
    }else
    {
        _zongjiaLabel.text = [NSString stringWithFormat:@"%0.2f",total - selectModel.money.floatValue];
    }
    
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
    label.textColor = [UIColor colorWithHexString:@"#444447"];
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


#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    if (request == orderReq) {
        
        NSArray* address = requestDic[@"address"];
        if (address.count>0) {
            NSDictionary* addressDic = address[0];
            _nickNameLabel.text = addressDic[@"rec_name"];
            _mobileLabel.text = addressDic[@"phone"];
            _addressLabel.text = [NSString stringWithFormat:@"%@",addressDic[@"address"]];
           aid = addressDic[@"id"];
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无默认邮寄地址" delegate:self cancelButtonTitle:@"立即前往" otherButtonTitles:@"稍后再去", nil];
            alert.tag = 666;
            [alert show];
        }
        NSArray* order = requestDic[@"order"];
        NSDictionary* orderDic = order[0];
//        _comNameLabel.text = orderDic[@"title"];
//        _postPrice.text = [NSString stringWithFormat:@"邮费:%@",orderDic[@"postprice"]];
//        _xiaojiLabel.text = [NSString stringWithFormat:@"￥%0.2f",[orderDic[@"odertotprice"] floatValue]];
//        sum = [orderDic[@"odertotprice"] floatValue];
//        _zongjiaLabel.text = [NSString stringWithFormat:@"%.2f",sum];
//        NSArray* goods = orderDic[@"goods"];
//        NSDictionary* goodDic = goods[0];
//        [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMG,goodDic[@"picurl"]]] placeholderImage:[UIImage imageNamed:@"loding1"]];
//        _nameLabel.text = goodDic[@"title"];
//        _messageLabel.text = goodDic[@"attrs"];
//        _priceLabel.text = [NSString stringWithFormat:@"￥%@",goodDic[@"price"]];
//        _numLabel.text = [NSString stringWithFormat:@"x%@",goodDic[@"num"]];
        
//        jsonDic = @{@"gid":goodDic[@"gid"],@"cid":goodDic[@"cid"],@"shopid":goodDic[@"commid"]};
        
        for (NSDictionary* shopDic in order) {
            carMerModel* shopModel = [[carMerModel alloc]init];
            [shopModel setValuesForKeysWithDictionary:shopDic];
            
            NSArray* goods = shopDic[@"goods"];
            [_tableSource removeAllObjects];
            for (NSDictionary* dic in goods) {
                carComModel* model = [[carComModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [shopModel.shopArr addObject:model];
            }
            [_tableSource addObject:shopModel];
        }
        [_tableView reloadData];
        [self getTotalPrice];
//        _zongjiaLabel.text = [NSString stringWithFormat:@"%.2f",sum];
//        _comNameLabel.text = _messageDic[@"name"];
//        _priceLabel.text = [NSString stringWithFormat:@"￥%@",_messageDic[@"price"]];
//        _numLabel.text = [NSString stringWithFormat:@"%@件",_messageDic[@"num"]];
//        
//        [gopayDic setObject:_messageDic[@"num"] forKey:@"num"];
//        
//        NSArray* postmode = shujuDic[@"postmode"];
//        NSDictionary* postDic = postmode[0];
//        _postPrice.text = [NSString stringWithFormat:@"￥%@",postDic[@"postprice"]];
//        
//        sum = [postDic[@"postprice"] floatValue]+ [_messageDic[@"price"] floatValue]*[_messageDic[@"num"] floatValue];
//        
//        [gopayDic setObject:postDic[@"id"] forKey:@"postmode"];
//        [gopayDic setObject:[NSString stringWithFormat:@"%.2f",sum] forKey:@"totalprice"];
//        
//        _xiaojiLabel.text = [NSString stringWithFormat:@"￥%.2f",sum];
//        _zongjiaLabel.text = [NSString stringWithFormat:@"%.2f",sum];
        NSArray* coupon = requestDic[@"coupon"];
        dateArr = [[NSMutableArray alloc]init];
        for (NSDictionary* dic  in coupon) {
            youhuiModel* model = [[youhuiModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [dateArr addObject:model];
        }
        
    }else if (request == gopayReq)
    {
        
        NSString* message = requestDic[@"message"];
        if ([message isEqualToString:@"1"]) {
            gopayViewController* root = [[gopayViewController alloc]init];
            root.ordernum = requestDic[@"ordernum"];
            root.totalPrice = _zongjiaLabel.text;
            root.yueMoney = requestDic[@"money"];
            root.payfreight = requestDic[@"payfreight"];
            [self.navigationController pushViewController:root animated:YES];
        }
    }else if (request == useReq)
    {
//        NSArray* point = requestDic[@"point"];
//        dateArr = [[NSMutableArray alloc]init];
//        for (NSDictionary* dic  in point) {
//            youhuiModel* model = [[youhuiModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
//            [dateArr addObject:model];
//        }
//        if (dateArr.count>0) {
//            
//            youhuiBottom* bottom = [[youhuiBottom alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            [self.view addSubview:bottom];
//            bottom.delegate = self;
//            bottom.tableSource = dateArr;
//            [bottom show];
//            
//        }else
//        {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无可用优惠券" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
//        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0&&alertView.tag == 666) {
        goodsViewController* root = [[goodsViewController alloc]init];
        [self.navigationController pushViewController:root animated:YES];
    }
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
    
    _zongjiaLabel.text = [NSString stringWithFormat:@"%.2f",sum - selectModel.money.floatValue];
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"生成订单";
        _label.font = [UIFont boldSystemFontOfSize:17];
        
    }
    
    return _label;
}

#pragma mark - xib

- (IBAction)addressBtn:(UIButton *)sender {
    
    goodsViewController* root = [[goodsViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
}

- (IBAction)gopayBtn:(UIButton *)sender {
    
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
    
    [gopayDic addEntriesFromDictionary:dic];
    if (selectModel != nil) {
        [gopayDic setObject:selectModel.password forKey:@"coupon_pwd"];
    }
    
    NSLog(@"%@",gopayDic);
    [HTTPRequest requestWitUrl:FORDINGDAN_IF andArgument:gopayDic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
        if ([requestDic[@"message"] isEqualToString:@"1"]) {
            gopayViewController* gopay = [[gopayViewController alloc]init];
            gopay.ordernum = requestDic[@"totordernum"];
            gopay.totalPrice = _zongjiaLabel.text;
            gopay.yueMoney = requestDic[@"money"];
            [self.navigationController pushViewController:gopay animated:YES];
        }
    } Falsed:^(NSError *error) {
        
    }];
    
//    gopayViewController* root = [[gopayViewController alloc]init];
//    [self.navigationController pushViewController:root animated:YES];
    
}
- (IBAction)couponBtn:(UIButton *)sender {
    
//    NSString* uid = [defaults objectForKey:@"uid"];
//    NSLog(@"%f",sum);
//    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",[NSString stringWithFormat:@"%f",sum],@"money", nil];
//    [useReq requestWitUrl:USEABLE_IF andArgument:dic andType:WXHTTPRequestGet];
    
    
    
}
- (IBAction)youhuiBtn:(UIButton *)sender {
    
    [self havecoupon];
}
@end
