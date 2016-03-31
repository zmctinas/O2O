//
//  creditsViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    WXCreditConvertType,
    WXCreditDetailType,
    WXCreditRecordType,
}WXCreditType;

@interface creditsViewController : fatherViewController

@property(nonatomic) WXCreditType type;

@end
