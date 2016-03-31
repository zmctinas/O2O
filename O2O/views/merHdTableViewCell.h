//
//  merHdTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface merHdTableViewCell : rootTableViewCell



- (IBAction)phoneCall:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UIButton *dingweiBtn;
- (IBAction)dingweiBtn:(UIButton *)sender;


@end
