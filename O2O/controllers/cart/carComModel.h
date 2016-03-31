//
//  carComModel.h
//  O2O
//
//  Created by wangxiaowei on 15/9/7.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface carComModel : rootModel

@property(copy,nonatomic)NSString* attrs;
@property(copy,nonatomic)NSString* carid;

@property(copy,nonatomic)NSString* con;
@property(copy,nonatomic)NSString* consume_points;
@property(copy,nonatomic)NSString* gid;
@property(copy,nonatomic)NSString* is_send_coupon;
@property(copy,nonatomic)NSString* num;
@property(copy,nonatomic)NSString* picurl;
@property(copy,nonatomic)NSString* salesprice;
@property(copy,nonatomic)NSString* title;
@property(copy,nonatomic)NSString* uid;
@property(assign,nonatomic)BOOL isSelect;

@property(copy,nonatomic)NSString* cid;
@property(copy,nonatomic)NSString* commid;
@property(copy,nonatomic)NSString* price;

@property(copy,nonatomic)NSString* ordernum;
@property(copy,nonatomic)NSString* gnum;


@end
