//
//  sortmenu.m
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "sortmenu.h"
#import "sortGoodsTableViewCell.h"

@implementation sortmenu
{
    UITableView* _firstView;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daxiao = frame;
        [self initmethod:frame];
    }
    return self;
}

-(void)setContro:(NSString *)contro
{
    _contro = contro;
    
    _firstView.tableFooterView = [[UIView alloc]init];
    
    if ([_contro isEqualToString:@"2"]) {
//        request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
//        [request requestWitUrl:COMMERQUAN_IF andArgument:nil andType:WXHTTPRequestGet];
        NSArray* names = @[@"最早发布",@"最新发布",@"热评",@"收藏数量",@"星级排序"];
        for (int i = 0 ; i<names.count; i++) {
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:names[i],@"name",[NSString stringWithFormat:@"%d",i+1],@"act", nil];
            [_tableSource addObject:dic];
        }
        [_firstView reloadData];
    }else if([_contro isEqualToString:@"1"])
    {
        NSArray* names = @[@"默认排序",@"最新发布",@"销量最高",@"价格最低",@"价格最高"];
        for (int i = 0 ; i<names.count; i++) {
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:names[i],@"name",[NSString stringWithFormat:@"%d",i+1],@"act", nil];
            [_tableSource addObject:dic];
        }
        [_firstView reloadData];
    }else
    {
        [HTTPRequest requestWitUrl:COM_CATE_IF andArgument:nil andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
            
            NSArray* list = requestDic[@"list"];
            for (NSDictionary* dic in list) {
                NSDictionary*  ddic = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"classname"],@"name",dic[@"id"],@"act", nil];
                [_tableSource addObject:ddic];
            }
            [_firstView reloadData];
        } Falsed:^(NSError *error) {
            
        }];
    }
}

-(void)initmethod:(CGRect)frame
{
    _tableSource = [[NSMutableArray alloc]init];
    _firstView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height)];
    _firstView.delegate = self;
    _firstView.dataSource = self;
    [self addSubview:_firstView];
    
    UINib* nib = [UINib nibWithNibName:@"sortGoodsTableViewCell" bundle:nil];
    [_firstView registerNib:nib forCellReuseIdentifier:@"firstcell"];
    
    
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    [_tableSource removeAllObjects];
    NSArray* shangquan = requestDic[@"shangquan"];
    for (NSDictionary* dic  in shangquan) {
        [_tableSource addObject:dic];
    }
    [_firstView reloadData];
}

#pragma mark - getter



#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    sortGoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"firstcell" forIndexPath:indexPath];
    
    NSDictionary* dic = _tableSource[indexPath.row];
    if ([_contro isEqualToString:@"1"]) {
        cell.nameLabel.text = dic[@"name"];
    }else
    {
        cell.nameLabel.text = dic[@"name"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _firstView) {
        
        if ([_contro isEqualToString:@"3"]) {
            UIButton* btn = (UIButton*)[_headerView viewWithTag:10];
            
            NSDictionary* dic = _tableSource[indexPath.row];
            
            [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"touchmerchant" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btn,@"btn",dic[@"act"],@"act",@"3",@"type", nil]];
            
        }else
        {
            UIButton* btn = (UIButton*)[_headerView viewWithTag:11];
            NSMutableDictionary* messageDic = [[NSMutableDictionary alloc]init];
            NSDictionary* dic = _tableSource[indexPath.row];
            [messageDic setObject:btn forKey:@"btn"];
            
            [messageDic setObject:@"2" forKey:@"type"];
            [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
            
            if ([_contro isEqualToString:@"1"]) {
                [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
                [messageDic setObject:dic[@"act"] forKey:@"act"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"touchheaderView" object:self userInfo:messageDic];
            }else
            {
                [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"touchmerchant" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btn,@"btn",dic[@"act"],@"act", nil]];
            }
        }
        
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


@end
