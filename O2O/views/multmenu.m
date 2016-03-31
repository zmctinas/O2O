//
//  multmenu.m
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "multmenu.h"
#import "cateDoodsTableViewCell.h"
#import "cateModel.h"
#import "UIColor+hexColor.h"
#import "rightTableViewCell.h"

@implementation multmenu
{
    UITableView* _firstView;
    NSMutableArray* _tableSource;
    NSMutableArray* _secondSource;
    NSInteger _index;
    HTTPRequest* firstReq;
    HTTPRequest* secondReq;
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
    if ([_contro isEqualToString:@"1"]) {
        firstReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
        
        [firstReq requestWitUrl:CATETYPE_IF andArgument:nil andType:WXHTTPRequestGet];
    }else
    {
        secondReq = [[HTTPRequest alloc]initWithtag:2 andDelegate:self];
        
        [secondReq requestWitUrl:COM_CATE_IF andArgument:nil andType:WXHTTPRequestGet];
    }
}

-(void)initmethod:(CGRect)frame
{
    
    _firstView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, frame.size.height)];
    
    _firstView.delegate = self;
    _firstView.dataSource = self;
    _firstView.layer.borderColor = [UIColor colorWithHexString:@"#F0F0F0"].CGColor;
    _firstView.layer.borderWidth = 0.3;
    [self addSubview:_firstView];
    
    if ([_firstView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [_firstView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_firstView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [_firstView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    _tableSource = [[NSMutableArray alloc]init];
    _secondSource = [[NSMutableArray alloc]init];
    
    UINib* nib = [UINib nibWithNibName:@"cateDoodsTableViewCell" bundle:nil];
    [_firstView registerNib:nib forCellReuseIdentifier:@"firstcell"];
    
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    
        if (request == firstReq) {
            NSArray* list  = requestDic[@"list"];
            [_tableSource removeAllObjects];
            for (NSDictionary* dic in list) {
                cateModel* model = [[cateModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_tableSource addObject:model];
            }
            [_firstView reloadData];
        }else if (request == secondReq)
        {
            NSArray* list  = requestDic[@"list"];
            [_tableSource removeAllObjects];
            for (NSDictionary* dic in list) {
                cateModel* model = [[cateModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_tableSource addObject:model];
            }
            [_firstView reloadData];
//            NSArray* goodstype  = requestDic[@"goodstype"];
//            [_secondSource removeAllObjects];
//            for (NSDictionary* dic in goodstype) {
//                cateModel* model = [[cateModel alloc]init];
//                [model setValuesForKeysWithDictionary:dic];
//                [_secondSource addObject:model];
//            }
            
            
        }
    
}

#pragma mark - getter

-(UITableView*)secondView
{
    if (!_secondView) {
        _secondView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH /2 , _daxiao.size.height)];
        _secondView.delegate = self;
        _secondView.dataSource = self;
        _secondView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        UINib* nib = [UINib nibWithNibName:@"rightTableViewCell" bundle:nil];
        [_secondView registerNib:nib forCellReuseIdentifier:@"rightcell"];
        if ([_secondView respondsToSelector:@selector(setSeparatorInset:)])
            
        {
            
            [_secondView setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([_secondView respondsToSelector:@selector(setLayoutMargins:)])
            
        {
            
            [_secondView setLayoutMargins:UIEdgeInsetsZero];
            
        }
        [self addSubview:_secondView];
    }
    return _secondView;
}

#pragma mark - UITableViewDataSource

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _firstView) {
        return _tableSource.count;
    }else if (tableView == _secondView)
    {
        return [_secondSource count];
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == _firstView) {
        cateDoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"firstcell" forIndexPath:indexPath];
        cateModel* model = _tableSource[indexPath.row];
        cell.nameLabel.text = model.classname;
        if (indexPath.row == 0&&isfirst == NO) {
            isfirst = YES;
            [_firstView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self tableView:_firstView didSelectRowAtIndexPath:indexPath];
        }

        
        
        

        return cell;
    }
    else
    {
        rightTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"rightcell" forIndexPath:indexPath];
        NSDictionary* dic = _secondSource[indexPath.row];
        cell.nameLabel.text = dic[@"classname"];
        cell.numLabel.text = dic[@"count"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
//    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _firstView) {
        _index = indexPath.row;
        cateModel* model = _tableSource[indexPath.row];
        _secondSource = [NSMutableArray arrayWithArray:model.next];
        [self.secondView reloadData];
    }else
    {
        
        UIButton* btn = (UIButton*)[_headerView viewWithTag:10];
        NSDictionary* dic = _secondSource[indexPath.row];
        
        [btn setTitle:dic[@"classname"] forState:UIControlStateNormal];
        
        if ([_contro isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"touchheaderView" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btn,@"btn",dic[@"id"],@"id",@"1",@"type", nil]];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"touchmerchant" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btn,@"btn",dic[@"id"],@"id",@"1",@"type", nil]];
        }
    
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
