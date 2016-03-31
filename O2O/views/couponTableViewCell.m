//
//  couponTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "couponTableViewCell.h"

@implementation couponTableViewCell

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
    _nameLbael.text = youhuiModel.title;
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",youhuiModel.money];
    _descriptionLabel.text = [NSString stringWithFormat:@"满%@可用",youhuiModel.meet_money];
    _passwordLabel.text = youhuiModel.password;
    _remainDayLabel.text = [NSString stringWithFormat:@"还剩%@天过期",youhuiModel.day];
//    NSArray* arr = [youhuiModel.endtime componentsSeparatedByString:@" "];
    _endTimeLabel.text = [NSString stringWithFormat:@"有效期至%@",youhuiModel.coutime];
    
}

@end
