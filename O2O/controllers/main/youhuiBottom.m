//
//  youhuiBottom.m
//  O2O
//
//  Created by wangxiaowei on 15/7/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "youhuiBottom.h"
#import "youhuiTableViewCell.h"
#import "UIColor+hexColor.h"

@implementation youhuiBottom

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - getter

-(UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _contentView.frame.size.height) style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIView*)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
        [_contentView addSubview:self.tableView];
    }
    return _contentView;
}

-(UIView*)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.7;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

#pragma mark - action

-(void)show
{
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self registercell];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [_tableView reloadData];
}

-(void)tapBackView:(UITapGestureRecognizer*)tap
{
    [self removeFromSuperview];
}

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"youhuiTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"youhuicell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    youhuiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"youhuicell" forIndexPath:indexPath];
    cell.youModel = _tableSource[indexPath.row];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, 200, 20)];
    label.text =@"可用优惠券";
    [view addSubview:label];
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 320, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#EBEBF1"];
    [view addSubview:line];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(sendMessage:)]) {
        [self.delegate performSelector:@selector(sendMessage:) withObject:_tableSource[indexPath.row]];
        [self removeFromSuperview];
    }
}

@end
