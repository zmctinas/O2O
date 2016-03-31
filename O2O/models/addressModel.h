//
//  addressModel.h
//  O2O
//
//  Created by wangxiaowei on 15/4/25.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface addressModel : rootModel

@property(strong)NSString* address;

@property(strong)NSString* name;

@property(strong)NSString* phone;

@property(strong)NSString* postcode;

@property(nonatomic)BOOL isSelected;

@end
