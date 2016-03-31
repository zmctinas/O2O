//
//  baseMessageTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "baseMessageTableViewCell.h"

@implementation baseMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)heightforcell
{
    return 90;
}

#pragma mark - setter

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    
    _nameLabel.text = merModel.comName;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _descriptions.text = merModel.descriptions;
    
    _saleNum.text = [NSString stringWithFormat:@"%ld",(long)merModel.num];
//    _remainTime.text = merModel.
    if (merModel.endtime.length>0) {
        
    }else
    {
        _endtimeView.hidden = YES;
    }
    
}

@end
