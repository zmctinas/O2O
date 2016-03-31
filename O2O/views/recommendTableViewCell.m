//
//  recommendTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "recommendTableViewCell.h"

@implementation recommendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    // Configure the view for the selected state
}

-(void)setCollectModel:(collectModel *)collectModel
{
    _collectModel = collectModel;
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,collectModel.commodityPic];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _nameLabel.text = collectModel.comName;
    _dspLabel.text = collectModel.descriptions;
    _nowLabel.text = [NSString stringWithFormat:@"￥%@",collectModel.currentprice];
    _nowLabel.adjustsFontSizeToFitWidth = YES;
    _oldLabel.text = [NSString stringWithFormat:@"￥%@",collectModel.originalprice];
}

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,merModel.smallPic];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _nameLabel.text = merModel.comName;
    
    _dspLabel.text = merModel.descriptions;
    
    _nowLabel.text = [NSString stringWithFormat:@"￥%@",merModel.currentprice];
    _nowLabel.adjustsFontSizeToFitWidth = YES;
    _oldLabel.text = [NSString stringWithFormat:@"￥%@",merModel.originalprice];
    
    
}

@end
