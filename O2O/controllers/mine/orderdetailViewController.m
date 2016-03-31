//
//  orderdetailViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/14.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "orderdetailViewController.h"
#import "attrsTableViewCell.h"
#import "evaluateViewController.h"

@interface orderdetailViewController ()<HTTPRequestDataDelegate,UITableViewDataSource,UITableViewDelegate>
{
    HTTPRequest* detailReq;
    NSDictionary* orders;
    NSMutableArray* _tableSource;
    NSUserDefaults* defaults;
}

@property(strong,nonatomic)UILabel* label;

@end

@implementation orderdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self registerCell];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    detailReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    [self requestDate];
    
    [self setdate];
    
//    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_orderid,@"orderid", nil];
//    
//    [detailReq requestWitUrl:ORDERDETAIL_IF andArgument:dic andType:WXHTTPRequestGet];
    
//    [_backScrollView addSubview:_contentview];
//    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 568);
    
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

-(void)requestDate
{
    NSString* uid = [defaults objectForKey:@"uid"];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_ordModel.gid,@"gid",_ordModel.ordernum,@"ordernum",uid,@"uid", nil];
    
    [HTTPRequest requestWitUrl:ORDERDETAIL_IF andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
        NSArray* order = requestDic[@"order"];
        NSDictionary* orderDic = order[0];
        _addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",orderDic[@"address"]];
        _orderPriceLabel.text = orderDic[@"totmoney"];
        if ([orderDic[@"act"] isEqualToString:@"4"]) {
            self.commentBtn.hidden = NO;
        }
    } Falsed:^(NSError *error) {
        
    }];
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    orders = requestDic[@"orders"];
    [self setdate];
    NSDictionary* attrs = requestDic[@"attrs"];
    _tableSource = [NSMutableArray arrayWithArray:attrs[@"goods"]];
    [_tableView reloadData];

}

#pragma mark - private

-(void)registerCell
{
    UINib* nib = [UINib nibWithNibName:@"attrsTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"attrscell"];
}

-(void)setdate
{
    _ordernumLabel.text = orders[@"ordernum"];
    _timeLabel.text = _ordModel.posttime;
    
    _nameLabel.text = _ordModel.title;
    _numLabel.text = [NSString stringWithFormat:@"x%@",_ordModel.gnum];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_ordModel.salesprice];
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _messageLabel.text = _ordModel.attrstrs;
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,_ordModel.picurl];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"订单详情";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    attrsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"attrscell" forIndexPath:indexPath];
    NSDictionary* dic = _tableSource[indexPath.row];
    cell.nameLabel.text = dic[@"attrs"];
    cell.numLabel.text = [NSString stringWithFormat:@"x%@",dic[@"num"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (IBAction)commentBtn:(UIButton *)sender {
    
    evaluateViewController* evaluate = [[evaluateViewController alloc]init];
    
    evaluate.model = _ordModel;
    evaluate.selectType = 1;
    
    [self.navigationController pushViewController:evaluate animated:YES];
    
}
@end
