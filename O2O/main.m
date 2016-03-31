//
//  main.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

//int main(int argc, char* argv[])
//{
//    @try {
//        @autoreleasepool
//        {
//            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//        }
//    }
//    @catch (NSException* exception)
//    {
//        NSLog(@"Exception=%@\nStack Trace:%@", exception, [exception callStackSymbols]);
//    }
//}