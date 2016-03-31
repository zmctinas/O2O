//
//  merHdTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "merHdTableViewCell.h"
#import "WXMapViewController.h"
#import "MerchantDetailViewController.h"
#import "commerListViewController.h"


@implementation merHdTableViewCell
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

-(void)setModel:(detailModel *)model
{
    [super setModel:model];
    
    _addressLabel.text = model.location;
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,model.merImg];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImage:)];
    [_iconView addGestureRecognizer:tap];
    
}

-(void)tapHeadImage:(UITapGestureRecognizer*)tap
{
    UIViewController* VC = (MerchantDetailViewController*)self.delegate;
    
    commerListViewController* list = [[commerListViewController alloc]init];
    list.commid = self.model.commid;
    list.title = self.model.merName;
    [VC.navigationController pushViewController:list animated:YES];
    
}

-(void)addDelegate:(id)delegate andAction:(SEL)action
{
    [super addDelegate:delegate andAction:action];
    
}

- (IBAction)phoneCall:(UIButton *)sender {
    
    NSString *phoneNum = self.model.merPhone;// 电话号码
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    
}
- (IBAction)dingweiBtn:(UIButton *)sender {
    
    UIViewController* VC = (UIViewController*)self.delegate;
    
    WXMapViewController* root = [[WXMapViewController alloc]init];
    root.latitude = self.model.latitude;
    root.longitude = self.model.longitude;
    [VC.navigationController pushViewController:root animated:YES];
    
}
@end
