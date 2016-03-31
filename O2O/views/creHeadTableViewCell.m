//
//  creHeadTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/5/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "creHeadTableViewCell.h"
#import "WXAlbum.h"
#import "AppDelegate.h"

@implementation creHeadTableViewCell
{
    float total;
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
}

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    NSString* imageUrl = nil;
    if (merModel.commoditys.count>0) {
        imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,merModel.commoditys[0]];
        
    }
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    
    _inteLabel.text = [NSString stringWithFormat:@"%@积分",merModel.integral];
    
    defaults = [NSUserDefaults standardUserDefaults];
}

- (IBAction)touchphotoBtn:(UIButton *)sender {
    
    UIApplication* application = [UIApplication sharedApplication];
    AppDelegate* delegate = application.delegate;
    UIWindow* window = delegate.window;
    WXAlbum* album = [[WXAlbum alloc]initWithFrame:window.frame];
    album.currentIndex = 0;
    album.imageUrls = self.merModel.commoditys;
    [window addSubview:album];
}

- (IBAction)goBuyBtn:(UIButton *)sender {
    
//    NSString* isMoren = [defaults objectForKey:@"isMoren"];
//    NSString* psfs = nil;
//    if (isMoren == nil) {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未选取配送方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }else if ([isMoren isEqualToString:@"1"])
//    {
//        psfs = @"1";
//    }else if ([isMoren isEqualToString:@"2"])
//    {
//        psfs = @"2";
//    }
    NSInteger num = [defaults integerForKey:@"intNum"];
    if (!num) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"数量不可为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString* uid = [defaults objectForKey:@"uid"];
    
    goBuyReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",[NSString stringWithFormat:@"%ld",(long)num],@"num",self.merModel.id,@"gid", nil];
    total = num * self.merModel.integral.floatValue;
    
    [goBuyReq requestWitUrl:EXCHANGE_IF andArgument:dic andType:WXHTTPRequestGet];
    
}

- (void)dealloc
{
    [defaults removeObjectForKey:@"isMoren"];
    [defaults removeObjectForKey:@"intNum"];
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    if ([message integerValue] == 1) {
        
        NSString* integral = [defaults objectForKey:@"integral"];
        
        integral = [NSString stringWithFormat:@"%ld",integral.integerValue - (int)total];
        [defaults setObject:integral forKey:@"integral"];
        
        [defaults synchronize];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"兑换成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        UIViewController* root = (UIViewController*)self.delegate;
        [root.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"兑换失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}

@end
