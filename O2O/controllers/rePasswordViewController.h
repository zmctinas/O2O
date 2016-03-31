//
//  rePasswordViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WXResetpassWord,
    WXResetmoblie,
}WXResetType;

@interface rePasswordViewController : fatherViewController

@property(nonatomic) WXResetType type;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;


@property (weak, nonatomic) IBOutlet UITextField *madeView;

@property (weak, nonatomic) IBOutlet UIImageView *woquimageView;


@end
