//
//  categoryModel.h
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface categoryModel : rootModel

@property(copy,nonatomic)NSString* classname;//名字

@property(copy,nonatomic)NSString* id;//id

@property(strong,nonatomic)NSMutableArray* cateArr;//分类数组


@end
