//
//  couponModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/19.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface couponModel : rootModel

@property(copy,nonatomic)NSString* consume_time;//剩余时间
@property(copy,nonatomic)NSString* expire_time;//剩余时间
@property(copy,nonatomic)NSString* descriptions;//描述
@property(copy,nonatomic)NSString* smallPic;//图片
@property(copy,nonatomic)NSString* salesprice;//单价
@property(copy,nonatomic)NSString* groupcoupon;//券码
@property(copy,nonatomic)NSString* num;//数量
@property(copy,nonatomic)NSString* comName;//名称
@property(copy,nonatomic)NSString* consume;//名称
@property(copy,nonatomic)NSString* id;//
@property(copy,nonatomic)NSString* state;//状态
@property(copy,nonatomic)NSString* checkinfo;//状态
@property(copy,nonatomic)NSString* create_time;//生成时间；
@property(copy,nonatomic)NSString* ordernum;//；
@property(copy,nonatomic)NSString* goods_id;//；

@end
