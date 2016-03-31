//
//  recomTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "delLineLabel.h"
#import "rootTableViewCell.h"

@interface recomTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView1;

@property (weak, nonatomic) IBOutlet UIImageView *iconview2;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;

@property (weak, nonatomic) IBOutlet UILabel *currentPrc1;

@property (weak, nonatomic) IBOutlet UILabel *currentPrc2;

@property (weak, nonatomic) IBOutlet delLineLabel *oldPrc1;

@property (weak, nonatomic) IBOutlet delLineLabel *oldPrc2;


@end
