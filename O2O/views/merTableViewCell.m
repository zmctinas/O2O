//
//  merTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "merTableViewCell.h"

@implementation merTableViewCell

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

-(void)setComModel:(commerModel *)comModel
{
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,comModel.merImg];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _nameLabel.text = comModel.merName;
    _locationLabel.text = comModel.location;
    _favoriteLabel.text = [NSString stringWithFormat:@"%@人",comModel.favorite];
    _star.numofStar = [comModel.stars intValue];
    _star.selectingenabled = NO;
    _pingjiaLabel.text = [NSString stringWithFormat:@"%@人评价>",comModel.comnum];
    
}

@end
