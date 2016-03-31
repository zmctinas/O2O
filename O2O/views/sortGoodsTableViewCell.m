//
//  sortGoodsTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "sortGoodsTableViewCell.h"

@implementation sortGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        _rightArr.image = [UIImage imageNamed:@"point_right_pink.png"];
        
    }else
    {
        _rightArr.image = [UIImage imageNamed:@"point_right_gray.png"];
        
    }
}

@end
