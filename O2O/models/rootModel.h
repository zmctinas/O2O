//
//  rootModel.h
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    WXGOODSMerchantMessage, 
    WXGOODSProductMessage,
    WXGoodsConsumeReminder,
    WXGoodsComment,
    WXGoodsRecommend,
    WXGoodsService,
    
}WXGoodsDetailType;

typedef enum {
    WXMyOrderUnPayType,
    WXMyOrderUnSendType,
    WXMyOrderUnReceiveType,
    WXMyOrderUnEvaluateType,
    WXMyGroupTicketUnusedType,
    WXMyGroupTicketUesedType,
}WXMyOrderState;

typedef enum {
    WXMainCategoty,//分类
    WXMainSale,//限时秒杀
    WXMainConvert,//积分商城
    WXMainRecommend,//每日推荐
}WXMainType;


@interface rootModel : NSObject

@property(nonatomic)WXGoodsDetailType type;
//
@property(nonatomic)WXMyOrderState orderType;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

-(id)valueForUndefinedKey:(NSString *)key;

-(void)setNilValueForKey:(NSString *)key;



@end
