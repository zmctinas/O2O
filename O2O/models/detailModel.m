//
//  detailModel.m
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "detailModel.h"

@implementation detailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _detailMsgs = [[NSMutableArray alloc]init];
        _comments = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
