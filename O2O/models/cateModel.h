//
//  cateModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/4.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface cateModel : rootModel

@property(copy,nonatomic)NSString* classname;

@property(copy,nonatomic)NSString* comName;

@property(copy,nonatomic)NSString* id;

@property(copy,nonatomic)NSString* num;

@property(strong,nonatomic)NSArray* next;



@end
