//
//  mainTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "mainTableViewCell.h"

@implementation mainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMerModel:(allMerModel *)merModel
{
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,merModel.smallPic];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    NSString* str = merModel.originalprice;
    NSLog(@"%@",NSStringFromClass([str class]));
    _nameLabel.text = merModel.comName;
    _NPLabel.text = merModel.salesprice;
    _NPLabel.adjustsFontSizeToFitWidth = YES;
    _OPLabel.text = merModel.originalprice;
    
    _dspLabel.text = merModel.descriptions;
    _salesLabel.text = [NSString stringWithFormat:@"已售%ld",merModel.num];
    
}

-(void)setMessages:(NSArray *)messages
{
    [super setMessages:messages];
    
    NSDictionary* dic = messages[self.tag];
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,[messages[self.tag] objectForKey:@"picurl"]];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    
    _nameLabel.text = dic[@"comName"];
    _NPLabel.text = dic[@"salesprice"];
    _NPLabel.adjustsFontSizeToFitWidth = YES;
    _OPLabel.text = [NSString stringWithFormat:@"￥%@",dic[@"originalprice"]];
    
    _dspLabel.text = dic[@"descriptions"];
    _salesLabel.text = [NSString stringWithFormat:@"已售%@",dic[@"num"]];
    
}

@end
