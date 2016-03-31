//
//  carMineModel.h
//  O2O
//
//  Created by wangxiaowei on 15/9/9.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface carMineModel : rootModel

@property(copy,nonatomic)NSString* title;
@property(copy,nonatomic)NSString* ordernum;
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* act;
@property(copy,nonatomic)NSString* checkinfo;
@property(strong,nonatomic)NSMutableArray* shopArr;

@property(strong,nonatomic)NSString* totmoney;
@property(strong,nonatomic)NSString* postmoney;
@property(strong,nonatomic)NSString* posttime;

@end
