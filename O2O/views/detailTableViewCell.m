//
//  detailTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "detailTableViewCell.h"

@implementation detailTableViewCell

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
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,merModel.inturl];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    
    if ([merModel.isused isEqualToString:@"N"]) {
        _useState.text = @"未使用";
        
    }else
    {
        _useState.text = @"已使用";
    }
    _numLabel.text = [NSString stringWithFormat:@"x%ld",(long)merModel.num];
    _nameLabel.text = merModel.name;
    _ordernum.text = [NSString stringWithFormat:@"兑换码：%@",merModel.ordernum];
    NSArray* arr = [merModel.time componentsSeparatedByString:@" "];
    _timeLabel.text = arr[0];
    if ([merModel.details_lx isEqualToString:@"1"]) {
        _changeLabel.text = [NSString stringWithFormat:@"+%@",merModel.inteNum];
        _useState.hidden = YES;
        _numLabel.hidden = YES;
        _ordernum.hidden = YES;
    }else
    {
        _changeLabel.text = [NSString stringWithFormat:@"-%@",merModel.inteNum];
        _useState.hidden = NO;
        _numLabel.hidden = NO;
        _ordernum.hidden = NO;
    }
    
}

@end
