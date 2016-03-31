//
//  adressModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/5.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface adressModel : rootModel

@property(copy,nonatomic)NSString* classname;//名字

@property(copy,nonatomic)NSString* id;//id

@property(copy,nonatomic)NSString* cur_address;//详细地址

@property(copy,nonatomic)NSString* phone;//电话

@property(copy,nonatomic)NSString* is_first;//是否为默认

@property(copy,nonatomic)NSString* rec_name;//名字

@property(copy,nonatomic)NSString* road_address;//取地址

@property(copy,nonatomic)NSString* zipcode;//邮编

@end
