//
//  carOrderTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/9/8.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carComModel.h"

@interface carOrderTableViewCell : UITableViewCell

@property(strong,nonatomic)carComModel* carModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;



@end
