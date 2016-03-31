//
//  recordModel.h
//  O2O
//
//  Created by wangxiaowei on 15/7/14.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface recordModel : rootModel

@property(copy,nonatomic)NSString* create_time;
@property(copy,nonatomic)NSString* money;
@property(copy,nonatomic)NSString* order_id;
@property(copy,nonatomic)NSString* state;

@end
