//
//  detailTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface detailTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *changeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backView;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *useState;
@property (weak, nonatomic) IBOutlet UILabel *ordernum;

@end
