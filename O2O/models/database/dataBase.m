//
//  dataBase.m
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "dataBase.h"


@implementation dataBase

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createDB];
    }
    return self;
}

-(void)createDB
{
    NSString* dirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* dbpath = [dirPath stringByAppendingPathComponent:@"O2O.db"];
    
    _dataBase = [[FMDatabase alloc]initWithPath:dbpath];
    
    BOOL isSet = [_dataBase open];
    if (isSet) {
        isSet = [_dataBase executeUpdate:@"create table if not exists search(ID integer primary key autoincrement,name varchar(128));"];
        if (!isSet) {
            NSString* errorMessage = [_dataBase lastErrorMessage];
            NSLog(@"创建表格失败%@",errorMessage);
        }else
        {
            NSLog(@"创建表格成功");
        }
    }else
    {
        NSLog(@"数据库创建（打开）失败");
    }
    
}

#pragma mark - private

-(NSMutableArray*)select:(NSString*)selectcode
{
    FMResultSet* set = [_dataBase executeQuery:@"select * from search;"];
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    while ([set next]) {
        NSString* str = [set stringForColumn:@"name"];
        [arr addObject:str];
    }
    return arr;
}

-(void)update
{
    NSString* sql = @"update search set name =? where name = ?;";
    BOOL isSet = [_dataBase executeUpdate:sql];
    if (!isSet) {
        NSLog(@"数据修改失败 %@",[_dataBase lastErrorMessage]);
    }else
    {
        NSLog(@"数据修改成功");
    }
}

-(void)delete
{
    NSString* sql = @"delete from search";
    BOOL isSet = [_dataBase executeUpdate:sql];
    if (!isSet) {
        NSLog(@"数据删除失败 %@",[_dataBase lastErrorMessage]);
    }else
    {
        NSLog(@"数据删除成功");
    }
    
}

-(void)insert:(NSString*)name
{
    NSString* sql = @"insert into search(name) values(?);";
    BOOL isSet = [_dataBase executeUpdate:sql,name];
    if (!isSet) {
        NSLog(@"数据增加失败 %@",[_dataBase lastErrorMessage]);
    }else
    {
        NSLog(@"数据增加成功");
    }
}

@end
