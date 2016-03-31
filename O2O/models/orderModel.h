//
//  orderModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface orderModel : rootModel

@property(copy,nonatomic)NSString* checkinfo;//订单状态
@property(copy,nonatomic)NSString* descriptions;//描述
@property(copy,nonatomic)NSString* gnum;//商品数量
@property(copy,nonatomic)NSString* goodsmoney;//商品总价
@property(copy,nonatomic)NSString* picurl;//商品图片
@property(copy,nonatomic)NSString* postmoney;//邮费
@property(copy,nonatomic)NSString* posttime;//交易时间
@property(copy,nonatomic)NSString* salesprice;//单价
@property(copy,nonatomic)NSString* title;//名称
@property(copy,nonatomic)NSString* totmoney;//总价
@property(copy,nonatomic)NSString* act;//订单状态
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* ordernum;
@property(copy,nonatomic)NSString* gid;
@property(strong,nonatomic)NSString* attrstrs;

@end
