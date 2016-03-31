//
//  serviceTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "serviceTableViewCell.h"

@implementation serviceTableViewCell

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
    
    if (model.descriptions.length>0) {
        _messageLabel.text = model.descriptions;
    }
    
     CGRect rect = [model.descriptions boundingRectWithSize:CGSizeMake(_messageLabel.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    
    CGFloat height = MAX(rect.size.height, _messageLabel.frame.size.height);
    
    [self performSelector:@selector(changeFrame:) withObject:[NSNumber numberWithFloat:height] afterDelay:0.1];
    
}

-(void)changeFrame:(NSNumber*)height
{
    _messageLabel.frame = CGRectMake(_messageLabel.frame.origin.x, _messageLabel.frame.origin.y, _messageLabel.frame.size.width, height.floatValue);
}

@end
