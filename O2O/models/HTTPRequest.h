//
//  HTTPRequest.h
//  O2O
//
//  Created by wangxiaowei on 15/5/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "WXProcess.h"

typedef enum {
    WXHTTPRequestGet,
    WXHTTPRequestPost,
}WXHTTPRequestType;
@class HTTPRequest;

typedef void (^FinishBolck)(NSURLResponse *response, NSDictionary* requestDic);

typedef void (^FalseBolck)(NSError *error);

@protocol HTTPRequestDataDelegate <NSObject>

-(void)request:(HTTPRequest* )request getMessage:(NSDictionary*)requestDic;

@end

@interface HTTPRequest : NSObject
{
    HTTPRequest* reaf;
    WXProcess* _process;
}

@property(assign,nonatomic)NSInteger tag;

@property(assign,nonatomic)id<HTTPRequestDataDelegate> delegate;

@property(strong,nonatomic)NSString* urlStr;

@property(strong,nonatomic)NSDictionary* argument;

@property(strong,nonatomic)NSMutableArray* parameter;

+(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type Finished:(FinishBolck)finishBlock Falsed:(FalseBolck)falseBolck;

- (instancetype)initWithtag:(NSInteger)tag andDelegate:(id<HTTPRequestDataDelegate>)delegate;

-(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type;

@end
