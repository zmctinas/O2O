//
//  detailModel.h
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface detailModel : rootModel

@property(copy,nonatomic)NSString* message;

@property(strong,nonatomic)NSMutableArray* detailMsgs;

@property(copy,nonatomic)NSString* title;

@property(copy,nonatomic)NSString* message_ts;

@property(copy,nonatomic)NSMutableArray* comments;

@property(copy,nonatomic)NSString* commid;

@property(copy,nonatomic)NSString* merName;


@property(copy,nonatomic)NSString* descriptions;
@property(copy,nonatomic)NSString* latitude;
@property(copy,nonatomic)NSString* longitude;
@property(copy,nonatomic)NSString* location;
@property(copy,nonatomic)NSString* merPhone;
@property(copy,nonatomic)NSString* merImg;

@end
