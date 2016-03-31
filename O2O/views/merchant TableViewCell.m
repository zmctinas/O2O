//
//  merchant TableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "merchant TableViewCell.h"
#import "detMsgViewController.h"

@implementation merchant_TableViewCell
{
    UIWebView* phoneCallWebView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    if (merModel.commoditys.count>0) {
        NSDictionary* dic = merModel.commoditys[0];
        _nameLabel.text = dic[@"businessName"];
        _addressLabel.text = dic[@"address"];
    }
    
    
}

-(void)setModel:(detailModel *)model
{
    [super setModel:model];
}

-(void)addDelegate:(id)delegate andAction:(SEL)action
{
    [super addDelegate:delegate andAction:action];
}

-(CGFloat)heightforcell
{
    return 90;
}

- (IBAction)phoneBtn:(UIButton *)sender {
    
    NSString *phoneNum = self.merModel.phoneNum;// 电话号码
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
}

- (IBAction)conditionBtn:(UIButton *)sender {
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"merchant",@"key", nil];
    
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:dic];
    }
    
    
}
@end
