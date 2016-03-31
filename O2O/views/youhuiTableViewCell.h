//
//  youhuiTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/7/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "youhuiModel.h"

@interface youhuiTableViewCell : UITableViewCell

@property(strong,nonatomic)youhuiModel* youModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
