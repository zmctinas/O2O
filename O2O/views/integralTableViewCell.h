//
//  integralTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface integralTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

- (IBAction)gopayBtn:(UIButton *)sender;


@end
