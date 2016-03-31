//
//  commentModel.h
//  O2O
//
//  Created by wangxiaowei on 15/6/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "rootModel.h"

@interface commentModel : rootModel

@property(copy,nonatomic)NSString* commentText;
@property(copy,nonatomic)NSString* commentTime;
@property(copy,nonatomic)NSString* nickname;
@property(copy,nonatomic)NSArray* picarr;
@property(copy,nonatomic)NSString* score;
@property(copy,nonatomic)NSString* title;





@end
