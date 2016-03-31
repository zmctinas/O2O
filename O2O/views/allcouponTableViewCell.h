//
//  allcouponTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/6/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface allcouponTableViewCell : rootTableViewCell<HTTPRequestDataDelegate>
{
    HTTPRequest* getReq;
    NSUserDefaults* defaults ;
}

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *meetLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@property (weak, nonatomic) IBOutlet UILabel *endLabel;

- (IBAction)getBtn:(UIButton *)sender;

@end
