//
//  youhuiBottom.h
//  O2O
//
//  Created by wangxiaowei on 15/7/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "youhuiModel.h"

@protocol bottomprotrol <NSObject>

-(void)sendMessage:(youhuiModel*)model;

@end

@interface youhuiBottom : UIView<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    HTTPRequest* attrReq;
}

@property(copy,nonatomic)NSString* gid;
@property(copy,nonatomic)NSString* comname;
@property(copy,nonatomic)NSString* price;

@property(assign)id<bottomprotrol> delegate;

@property(assign)SEL action;

@property(strong,nonatomic)NSMutableArray* tableSource;

@property(strong,nonatomic)UIView* contentView;

@property(strong,nonatomic)UIView* btnView;

@property(strong,nonatomic)UIView* headView;

@property(strong,nonatomic)UIView* backView;

@property(strong,nonatomic)UITableView* tableView;

-(void)show;

//-(void)addorderDelegate:(id)delegate AndAction:(SEL)action;


@end
