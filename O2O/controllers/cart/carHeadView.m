//
//  carHeadView.m
//  O2O
//
//  Created by wangxiaowei on 15/9/6.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "carHeadView.h"

@implementation carHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [FrameSize MLBFrameSize:self];
    }
    return self;
}

-(void)setTitleLabel:(UILabel *)titleLabel
{
    _titleLabel = titleLabel;
    
    [FrameSize MLBFrameSize:self];
}

@end
