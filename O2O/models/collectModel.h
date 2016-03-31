//
//  collectModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/19.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface collectModel : rootModel

@property(copy,nonatomic)NSString* comName;//名称；
@property(copy,nonatomic)NSString* commodityID;//id
@property(copy,nonatomic)NSString* commodityPic;//图片
@property(copy,nonatomic)NSString* currentprice;//价格
@property(copy,nonatomic)NSString* originalprice;//原价
@property(copy,nonatomic)NSString* collectid;//id
@property(copy,nonatomic)NSString* descriptions;

@end
