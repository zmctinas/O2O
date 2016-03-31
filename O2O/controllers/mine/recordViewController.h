//
//  recordViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WXCreditRecordPay,
    WXCreditRecordUse,
}WXCreditRecordType;

@interface recordViewController : fatherViewController

@property(assign)WXCreditRecordType recordType;

@end
