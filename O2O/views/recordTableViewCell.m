//
//  recordTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "recordTableViewCell.h"

@implementation recordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

-(void)setReModel:(recordModel *)reModel
{
    _reModel = reModel;
    if (_type) {
        _firstLabel.text = reModel.create_time;
        _secondLabel.text = reModel.money;
        _thirdLabel.text = reModel.state;
    }else
    {
        _firstLabel.text = reModel.order_id;
        _secondLabel.text = reModel.create_time;
        _thirdLabel.text = [NSString stringWithFormat:@"%@元",reModel.money];
    }
    
    //    _tableView.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
    //    _tableView.layer.borderWidth = 0.5;
}

@end
