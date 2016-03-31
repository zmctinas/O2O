//
//  rootTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
#import "allMerModel.h"
#import "youhuiModel.h"
#import "commentModel.h"

@interface rootTableViewCell : UITableViewCell

@property(assign,nonatomic)NSInteger index;

@property(copy,nonatomic)NSString* typeid;

@property (assign)id delegate;

@property (assign) SEL action;

@property (strong , nonatomic)detailModel* model;

@property(nonatomic,strong)NSArray* messages;

@property(nonatomic,strong)allMerModel* merModel;

@property(strong,nonatomic)youhuiModel* youhuiModel;

@property(strong,nonatomic)commentModel* comModel;

-(void)addDelegate:(id)delegate andAction:(SEL)action;

//-(CGFloat)heightforcell;

@end
