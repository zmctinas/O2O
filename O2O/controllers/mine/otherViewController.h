//
//  otherViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WXCommdityRecommendType,
    WXCommdityConvertType,
    WXCommditySaleType,
}WXCommdityCategory;

@interface otherViewController : fatherViewController

@property(nonatomic)WXCommdityCategory type;

@property (weak, nonatomic) IBOutlet UIView *headView;

@property(strong,nonatomic)NSString* ismine;



@end
