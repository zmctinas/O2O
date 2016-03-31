//
//  couponTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"


@interface couponTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbael;

@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *remainDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end
