//
//  allMerModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/1.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface allMerModel : rootModel

@property(copy,nonatomic)NSString* originalprice;//原价

@property(copy,nonatomic)NSString* salesprice;//现价

@property(copy,nonatomic)NSString* smallPic;//小图片

@property(copy,nonatomic)NSString* bigPic;//大图片

@property(copy,nonatomic)NSString* phoneNum;

@property(copy,nonatomic)NSString* descriptions;//描述
@property(copy,nonatomic)NSString* endtime;//描述

@property(assign,nonatomic)NSInteger num;//数量

@property(copy,nonatomic)NSString* comName;//名称

@property(copy,nonatomic)NSString* numdsc;//数量描述

@property(copy,nonatomic)NSString* timedsc;//时间描述

@property(copy,nonatomic)NSString* id;//商品id
@property(copy,nonatomic)NSString* commodityID;

@property(copy,nonatomic)NSString* currentprice;//现价

@property(copy,nonatomic)NSString* integral;//积分

@property(copy,nonatomic)NSString* title;
@property(strong,nonatomic)NSMutableArray* commoditys;
@property(copy,nonatomic)NSString* message;
@property(copy,nonatomic)NSString* body;
@property(copy,nonatomic)NSString* message_ts;


@property(copy,nonatomic)NSString* inteNum;
@property(copy,nonatomic)NSString* inturl;
@property(copy,nonatomic)NSString* name;
@property(copy,nonatomic)NSString* time;
@property(copy,nonatomic)NSString* title_id;
@property(copy,nonatomic)NSString* details_lx;

@property(copy,nonatomic)NSString* latitude;
@property(copy,nonatomic)NSString* longitude;

@property(copy,nonatomic)NSString* isused;
@property(copy,nonatomic)NSString* ordernum;

@property(copy,nonatomic)NSString* ydfs;

@end
