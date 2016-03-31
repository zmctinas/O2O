//
//  cateCollectionViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/5/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "cateCollectionViewCell.h"

@implementation cateCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(allMerModel *)model
{
    _model = model;
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,model.smallPic];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _nameLabel.text = model.comName;
    
}

@end
