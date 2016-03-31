//
//  carOrderTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/9/8.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "carOrderTableViewCell.h"

@implementation carOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [FrameSize MLBFrameSize:self];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCarModel:(carComModel *)carModel
{
    _carModel = carModel;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMG,carModel.picurl]] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _nameLabel.text = carModel.title;
    _messageLabel.text = carModel.attrs;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",carModel.price];
    _numLabel.text = [NSString stringWithFormat:@"x%@",carModel.num];
}

@end
