//
//  commerModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/2.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface commerModel : rootModel

@property(copy,nonatomic)NSString* comnum;//评价数

@property(copy,nonatomic)NSString* favorite;//喜欢数

@property(copy,nonatomic)NSString* location;//具体位置

@property(copy,nonatomic)NSString* latitude;//经度

@property(copy,nonatomic)NSString* longitude;//纬度

@property(copy,nonatomic)NSString* merImg;//纬度

@property(copy,nonatomic)NSString* merPhone;//电话

@property(copy,nonatomic)NSString* stars;//星级

@property(copy,nonatomic)NSString* merName;//名称

@property(copy,nonatomic)NSString* id;




@property(copy,nonatomic)NSString* address;//地址
@property(copy,nonatomic)NSString* businessDsp;//描述
@property(copy,nonatomic)NSString* businessName;//名字



@end
