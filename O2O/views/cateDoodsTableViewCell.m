//
//  cateDoodsTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "cateDoodsTableViewCell.h"
#import "UIColor+hexColor.h"

@implementation cateDoodsTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView* view = [[UIView alloc]initWithFrame:self.frame];
    view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    self.selectedBackgroundView = view;

    if (selected) {
        _rightarr.image = [UIImage imageNamed:@"point_right_pink.png"];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#FF658F"];
    }else
    {
        _rightarr.image = [UIImage imageNamed:@"point_right_gray.png"];
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    // Configure the view for the selected state
}

-(void)setBackView:(NSString *)backView
{
    if ([backView isEqualToString:@"1"]) {
        _rightarr.image = [UIImage imageNamed:@"point_right_pink.png"];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#FF658F"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        
    }else
    {
        _rightarr.image = [UIImage imageNamed:@"point_right_gray.png"];
        self.nameLabel.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
