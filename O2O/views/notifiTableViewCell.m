//
//  notifiTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "notifiTableViewCell.h"

@implementation notifiTableViewCell

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
    
    NSArray* arr = [youhuiModel.posttime componentsSeparatedByString:@" "];
    _timeLabel.text = arr[0];
    _messageLabel.text = youhuiModel.content;
    
}


@end
