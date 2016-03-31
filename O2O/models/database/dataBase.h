//
//  dataBase.h
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface dataBase : NSObject
@property (strong,nonatomic)FMDatabase* dataBase;

-(NSMutableArray*)select:(NSString*)selectcode;
-(void)insert:(NSString*)name;
-(void)delete;

@end
