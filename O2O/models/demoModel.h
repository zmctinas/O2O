//
//  demoModel.h
//  gaode_demo
//
//  Created by wangxiaowei on 15/6/9.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface demoModel : MAPointAnnotation

@property(copy,nonatomic)NSString* name;

@property(copy,nonatomic)NSString* address;

@property(assign,nonatomic)double jingdu;

@property(assign,nonatomic)double weidu;



@end
