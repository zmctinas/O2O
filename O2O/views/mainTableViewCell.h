//
//  mainTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"
#import "delLineLabel.h"
#import "allMerModel.h"

@interface mainTableViewCell : rootTableViewCell

@property(strong,nonatomic)allMerModel* merModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dspLabel;

@property (weak, nonatomic) IBOutlet UILabel *NPLabel;

@property (weak, nonatomic) IBOutlet delLineLabel *OPLabel;

@property (weak, nonatomic) IBOutlet UILabel *salesLabel;


@end
