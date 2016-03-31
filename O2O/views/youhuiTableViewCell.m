//
//  youhuiTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/7/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "youhuiTableViewCell.h"

@implementation youhuiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setYouModel:(youhuiModel *)youModel
{
    _youModel = youModel;
    
    _nameLabel.text = youModel.title;
    _numLabel.text = [NSString stringWithFormat:@"金额%@元",youModel.money];
    
}

@end
