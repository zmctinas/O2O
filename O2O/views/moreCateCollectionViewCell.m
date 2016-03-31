//
//  moreCateCollectionViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "moreCateCollectionViewCell.h"

@implementation moreCateCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"#D0D0D0"].CGColor;
    self.backView.layer.borderWidth = 1;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    
}

@end
