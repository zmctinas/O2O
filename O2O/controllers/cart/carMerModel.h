//
//  carMerModel.h
//  O2O
//
//  Created by wangxiaowei on 15/9/7.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface carMerModel : rootModel

@property(copy,nonatomic)NSString* cid;
@property(copy,nonatomic)NSString* title;
@property(strong,nonatomic)NSMutableArray* shopArr;

@property(copy,nonatomic)NSString* odertotprice;
@property(copy,nonatomic)NSString* postprice;
@property(copy,nonatomic)NSString* commid;



@end
