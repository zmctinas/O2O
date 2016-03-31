//
//  filtGoodsTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "filtGoodsTableViewCell.h"

@implementation filtGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initbutton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)initbutton
{
    NSArray* arr = [self.contentView subviews];
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"border"] forState:UIControlStateSelected];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)touchBtn:(UIButton *)sender {
    
    sender.selected = YES;
    NSArray* arr = [self.contentView subviews];
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag != sender.tag) {
                btn.selected = NO;
                
            }
        }
    }
    
    if ([_delegate respondsToSelector:_action]) {
        [_delegate performSelector:_action withObject:sender];
    }
    
}

-(void)addtap:(id)delegate andAction:(SEL)action
{
    _delegate = delegate;
    _action = action;
}
@end
