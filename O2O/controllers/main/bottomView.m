//
//  bottomView.m
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "bottomView.h"
#import "bottomTableViewCell.h"
#import "UIColor+hexColor.h"
#import "orderViewController.h"
#import "attModel.h"

@implementation bottomView
{
    NSInteger height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changenum" object:nil];
    _btnView = nil;
    
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    
    NSArray* att = requestDic[@"att"];
    for (NSDictionary* dic in att) {
        attModel* model = [[attModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_tableSource addObject:model];
    }
    [_tableView reloadData];
}

-(void)setGid:(NSString *)gid
{
    _gid = gid;
    _tableSource = [[NSMutableArray alloc]init];
    [self request];
    [self initView];
}

#pragma mark - getter

-(UIView*)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    }
    return _contentView;
}

-(UIView*)headView
{
    if (_headView == nil) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _headView.backgroundColor =[UIColor whiteColor];
        UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width - 50, 20)];
        title.text = _comname;
        title.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [_headView addSubview:title];
        
        UILabel* price = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 40, 15)];
        price.text = @"单价：";
        price.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        price.font = [UIFont systemFontOfSize:12];
        [_headView addSubview:price];
        
        UILabel* descripe = [[UILabel alloc]initWithFrame:CGRectMake(45, 30, 80, 15)];
        descripe.text = [NSString stringWithFormat:@"%@元",_price];
        descripe.font = [UIFont systemFontOfSize:12];
        descripe.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [_headView addSubview:descripe];
        
        UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setFrame:CGRectMake(self.frame.size.width - 45, 5, 40, 40)];
        [back addTarget:self action:@selector(touchback:) forControlEvents:UIControlEventTouchUpInside];
        back.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [_headView addSubview:back];
        
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, _headView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        [_headView addSubview:line];
        
    }
    
    return _headView;
}

-(UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40-208, self.frame.size.width, 208)style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIView*)btnView
{
    if (_btnView == nil) {
        _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, self.frame.size.width, 40)];
        
        _btnView.backgroundColor = [UIColor whiteColor];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(25, 5, 270, 30)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"loginbtn.png"] forState:UIControlStateNormal];
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [button addTarget:self action:@selector(querenBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:button];
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _btnView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        [_btnView addSubview:line];
    }
    
    return _btnView;
}

#pragma mark - private

-(void)addorderDelegate:(id)delegate AndAction:(SEL)action
{
    _delegate = delegate;
    _action = action;
}

-(void)touchback:(UIButton*)sender
{
    [self removeFromSuperview];
}

-(void)querenBtn:(UIButton*)sender
{
    NSMutableArray* attSource = [[NSMutableArray alloc]init];
    NSInteger sum = 0 ;
    for (attModel* model in _tableSource) {
        if (model.num) {
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:model.attrs,@"attrs",model.id,@"id",model.num,@"num", nil];
            [attSource addObject:dic];
        }
        
        sum += [model.num integerValue];
        
    }
    NSDictionary* messageDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)sum],@"num",_comname,@"name",_price,@"price", nil];
    
    if (sum == 0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您喜爱的商品" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }else if ([messageDic[@"num"] integerValue]>_canbuynum.integerValue)
    {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您最多还能购买%@件该商品",_canbuynum] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([_delegate respondsToSelector:_action]) {
        [_delegate performSelector:_action withObject:attSource withObject:messageDic];
    }
    
    [self removeFromSuperview];
    
    
}

-(void)registercell
{
    UINib* bottom = [UINib nibWithNibName:@"bottomTableViewCell" bundle:nil];
    [self.tableView registerNib:bottom forCellReuseIdentifier:@"bottomcell"];
}

-(void)changenum:(NSNotification*)userinfo
{
    NSDictionary* dic = [userinfo userInfo];
    NSString* key = dic[@"key"];
    if ([key isEqualToString:@"btn"]) {
        attModel* model = _tableSource[[dic[@"row"] integerValue]];
        NSInteger num = [model.num integerValue];
        
        if ([dic[@"action"] isEqualToString:@"plus"]) {
            num++;
        }else
        {
            num--;
        }
        model.num = [NSString stringWithFormat:@"%ld",(long)num];
//        NSString* num = dic[@"row"];
//        NSLog(@"%@",num);
    }
    for (attModel* model in _tableSource) {
        
    }
}

-(void)changecontent:(NSNotification*)userinfo
{
    
    if (self.frame.origin.x - _contentView.frame.origin.x == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint center = _contentView.center;
            center.y -= 250;
            _contentView.center = center;
        }];
    }
    
}

-(void)request
{
    attrReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_gid,@"gid", nil];
    
    [attrReq requestWitUrl:ATTR_IF andArgument:dic andType:WXHTTPRequestGet];
    
    
}

-(void)initView
{
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha=  0.7;
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchbackView:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [backView addGestureRecognizer:tap];
    [self.contentView addSubview:backView];
    
    [self addSubview:self.contentView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changenum:) name:@"changenum" object:nil];
    
    [_contentView addSubview:self.btnView];
    
    [self registercell];
    
    [_contentView addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changenum:) name:UITextViewTextDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changecontent:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
}

-(void)touchbackView:(UITapGestureRecognizer*)tap
{
    [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bottomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"bottomcell" forIndexPath:indexPath];
    attModel* model = _tableSource[indexPath.row];
    
    cell.tag = indexPath.row;
    
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

@end
