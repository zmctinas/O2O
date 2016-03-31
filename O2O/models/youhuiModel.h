//
//  youhuiModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface youhuiModel : rootModel

@property(copy,nonatomic)NSString* day;//剩余天数
@property(copy,nonatomic)NSString* endtime;//结束时间
@property(copy,nonatomic)NSString* meet_money;//使用条件
@property(copy,nonatomic)NSString* money;//面额
@property(copy,nonatomic)NSString* o_id;//是否使用
@property(copy,nonatomic)NSString* password;//密码
@property(copy,nonatomic)NSString* title;//名称
@property(copy,nonatomic)NSString* starttime;//开始时间
@property(copy,nonatomic)NSString* id;//id
@property(copy,nonatomic)NSString* picurl;//图片
@property(copy,nonatomic)NSString* coutime;//

@property(copy,nonatomic)NSString* content;//图片
@property(copy,nonatomic)NSString* posttime;//图片


@end
