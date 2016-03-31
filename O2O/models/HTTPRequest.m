//
//  HTTPRequest.m
//  O2O
//
//  Created by wangxiaowei on 15/5/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "HTTPRequest.h"


@implementation HTTPRequest
{
    AFHTTPRequestOperationManager* _manager;
}

- (instancetype)initWithtag:(NSInteger)tag andDelegate:(id<HTTPRequestDataDelegate>)delegate
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _parameter = [[NSMutableArray alloc]init];
        _delegate = delegate;
        _tag = tag;
        _process = [[WXProcess alloc]init];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _parameter = [[NSMutableArray alloc]init];
        _process = [[WXProcess alloc]init];
    }
    return self;
}



+(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type Finished:(FinishBolck)finishBlock Falsed:(FalseBolck)falseBolck
{
    AFHTTPRequestOperationManager* _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    NSMutableArray* _parameter = [[NSMutableArray alloc]init];
    NSString* _urlStr = [NSString stringWithFormat:@"%@%@",HEADURL,urlStr];
    WXProcess * process = [[WXProcess alloc]init];
    [process start];
    if (type == WXHTTPRequestGet) {
        
        [_manager GET:_urlStr parameters:argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",operation.response.URL);
            
            [process stop];
            finishBlock(operation.response,(NSDictionary*)responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error.description);
            NSLog(@"%@",operation.response.URL);
            NSLog ( @"operation: %@" , operation. responseString );
            falseBolck(error);
            [process stop];
        }];
    }else
    {
        [_manager POST:_urlStr parameters:argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            finishBlock(operation.response,(NSDictionary*)responseObject);
            [process stop];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error.description);
            NSLog(@"%@",operation.response.URL);
            NSLog ( @"operation: %@" , operation. responseString );
            falseBolck(error);
            [process stop];
        }];
    }
}

-(void)dealloc
{
//    _manager.
}


-(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type
{
    
    _urlStr = [NSString stringWithFormat:@"%@%@",HEADURL,urlStr];
    
    NSLog(@"%@",argument);
    NSLog(@"%@",_urlStr);
    if (type == WXHTTPRequestGet) {
        
        _argument = argument;
        [self requestGet];
    }else
    {
        _argument = argument;
        [self requestPost];
    }
    
}

-(void)requestGet
{
    [_process start];
    [_manager GET:_urlStr parameters:_argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.response.URL);
        if ([_delegate respondsToSelector:@selector(request:getMessage:)]) {
            [_delegate performSelector:@selector(request:getMessage:) withObject:self withObject:(NSDictionary*)responseObject];
        }
        [_process stop];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        NSLog(@"%@",operation.response.URL);
         NSLog ( @"operation: %@" , operation. responseString );
        [_process stop];
    }];
    
}

-(void)requestPost
{
    
    [_manager POST:_urlStr parameters:_argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([_delegate respondsToSelector:@selector(request:getMessage:)]) {
            [_delegate performSelector:@selector(request:getMessage:) withObject:self withObject:(NSDictionary*)responseObject];
        }
        [_process stop];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        NSLog(@"%@",operation.response.URL);
        NSLog ( @"operation: %@" , operation. responseString );
    }];
    [_process start];
}

@end
