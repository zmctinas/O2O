//
//  categoryTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "categoryTableViewCell.h"
#import "UIColor+hexColor.h"


@implementation categoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessages:(NSMutableArray *)messages
{
    [super setMessages:messages];
    
    NSInteger w = 0,h = 0;
    for (int i = 0 ; i < messages.count ; i++) {
        NSDictionary* dic = messages[i];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16+w*(60+16), 10+h*(105), 60, 60)];
        imageView.image = [UIImage imageNamed:dic[@"image"]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 10 + i;
        [self.contentView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        label.center = CGPointMake(imageView.center.x, imageView.center.y + 50);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = dic[@"name"];
        label.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCategory:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        
        w++;
        if (w == 4) {
            h++;
            w = 0;
        }
    }
    
}

-(void)tapCategory:(UITapGestureRecognizer*)tap
{
    UIImageView* imageView = (UIImageView*)tap.view;
    NSInteger index = imageView.tag;
    
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:[NSNumber numberWithInteger:index]];
       
        
    }
}

-(void)addDelegate:(id)delegate andAction:(SEL)action
{
    self.delegate = delegate;
    self.action = action;
}

@end
