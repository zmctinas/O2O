//
//  filtmenu.m
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "filtmenu.h"
#import "filtGoodsTableViewCell.h"
#import "UIColor+hexColor.h"

@implementation filtmenu
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

-(void)initmethod:(CGRect)frame
{
    
    _firstView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height)style:UITableViewStylePlain];
    
    _firstView.delegate = self;
    _firstView.dataSource = self;
    [self addSubview:_firstView];
    
    
    UINib* nib = [UINib nibWithNibName:@"filtGoodsTableViewCell" bundle:nil];
    [_firstView registerNib:nib forCellReuseIdentifier:@"firstcell"];
    
    
}

-(void)quedingBtn:(UIButton*)sender
{
    
    if (selectBtn == nil) {
        return;
    }
    
    UIButton* btn = (UIButton*)[_headerView viewWithTag:12];
    [btn setTitle:selectBtn.currentTitle forState:UIControlStateNormal];
    NSString* low = nil;
    NSString* high = nil;
    
    switch (selectBtn.tag - 10) {
        case 0:
            low = @"";
            high = @"";
            break;
        case 1:
            low = @"0";
            high = @"50";
            break;
        case 2:
            low = @"51";
            high = @"100";
            break;
        case 3:
            low = @"101";
            high = @"300";
            break;
        case 4:
            low = @"301";
            high = @"500";
            break;
        case 5:
            low = @"501";
            high = @"999";
            break;
        case 6:
            low = @"1000";
            high = @"9999999";
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary* messageDic = [[NSMutableDictionary alloc]init];
    [messageDic setObject:low forKey:@"low"];
    [messageDic setObject:high forKey:@"high"];
    [messageDic setObject:btn forKey:@"btn"];
    [messageDic setObject:@"3" forKey:@"type"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchheaderView" object:self userInfo:messageDic];
}

-(void)tapBtn:(UIButton*)sender
{
    
    
    selectBtn = sender;
    
    
}

#pragma mark - getter

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    filtGoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"firstcell" forIndexPath:indexPath];
    
    [cell addtap:self andAction:@selector(tapBtn:)];
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _firstView) {
        
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    view.userInteractionEnabled = YES;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20, 3, 270, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"input"] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:1.000f green:0.408f blue:0.576f alpha:1.00f] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(quedingBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#EBEBEC"];
    [view addSubview:line];
    
//    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    line2.backgroundColor = [UIColor colorWithHexString:@"#C6C6C6"];
//    [view addSubview:line2];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 20)];
    label.text = @"价格";
    [view addSubview:label];
    
    return view;
}



@end
