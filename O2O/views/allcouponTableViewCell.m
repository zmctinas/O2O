//
//  allcouponTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/6/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "allcouponTableViewCell.h"

@implementation allcouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setYouhuiModel:(youhuiModel *)youhuiModel
{
    [super setYouhuiModel:youhuiModel];
    _moneyLabel.text = youhuiModel.money;
    _startLabel.text = youhuiModel.starttime;
    _startLabel.adjustsFontSizeToFitWidth = YES;
    _endLabel.text = youhuiModel.endtime;
    _endLabel.adjustsFontSizeToFitWidth = YES;
    NSArray* arr1 = [youhuiModel.starttime componentsSeparatedByString:@" "];
    NSString* startStr = arr1[0];
    NSArray* arr2 = [youhuiModel.endtime componentsSeparatedByString:@" "];
    NSString* endtStr = arr2[0];
    _timeLabel.text = [NSString stringWithFormat:@"%@-%@",startStr,endtStr];
    _nameLabel.text = youhuiModel.title;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _meetLabel.text = [NSString stringWithFormat:@"满%@元可用",youhuiModel.meet_money];
}


- (IBAction)getBtn:(UIButton *)sender {
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString* uid = [defaults objectForKey:@"uid"];
    
    getReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",self.youhuiModel.id,@"pid", nil];

    [getReq requestWitUrl:ADDCOUPON_IF andArgument:dic andType:WXHTTPRequestGet];
    
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    NSString* tishi = nil;
    if ([message isEqualToString:@"1"]) {
        tishi = @"领取成功";
    }else
    {
        tishi = @"领取失败";
    }
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tishi delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
}

@end
