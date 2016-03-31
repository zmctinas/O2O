//
//  rootTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootTableViewCell.h"

@implementation rootTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

-(void)addDelegate:(id)delegate andAction:(SEL)action
{
    _delegate = delegate;
    _action = action;
}

#pragma mark - setter

-(void)setModel:(detailModel *)model
{
    _model = model;
}

-(void)setMerModel:(allMerModel *)merModel
{
    _merModel = merModel;
}

-(void)setMessages:(NSMutableArray *)messages
{
    if (_messages == nil) {
        _messages = [[NSMutableArray alloc]init];
    }
    _messages = messages;
}


@end
