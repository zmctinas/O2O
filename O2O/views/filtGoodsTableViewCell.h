//
//  filtGoodsTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface filtGoodsTableViewCell : UITableViewCell

@property(assign) id delegate;
@property SEL action;
- (IBAction)touchBtn:(UIButton *)sender;

-(void)addtap:(id)delegate andAction:(SEL)action;

@end
