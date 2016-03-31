//
//  moreViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "Reachability.h"

@interface moreViewController : UIViewController
{
    NSUserDefaults* defaults;
    BOOL isWifi;
}

@property(strong,nonatomic)Reachability* conn;
@property(nonatomic,strong)NSString* title;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

- (IBAction)clearImg:(UIButton *)sender;


@end
