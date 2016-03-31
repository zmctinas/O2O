//
//  WXPayStart.h
//  TiaoWei
//
//  Created by dukai on 15/3/9.
//  Copyright (c) 2015年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WXPayStart : NSObject

+(WXPayStart *)share;

- (void)sendPay:(NSString *)orderNum amount:(NSString *)amount orderName:(NSString *)orderName;
@end
