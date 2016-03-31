//
//  addressManageViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/25.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

@protocol WXAddressDelegate <NSObject>

-(void)sendAddress:(addressModel*)model;

@end

@interface addressManageViewController : fatherViewController

@property(assign) id<WXAddressDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end
