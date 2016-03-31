//
//  baseMessageTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface baseMessageTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptions;

@property (weak, nonatomic) IBOutlet UILabel *saleNum;

@property (weak, nonatomic) IBOutlet UILabel *remainTime;

@property (weak, nonatomic) IBOutlet UIView *endtimeView;



@end
