//
//  merTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentStar.h"
#import "rootTableViewCell.h"
#import "commerModel.h"

@interface merTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

@property (weak, nonatomic) IBOutlet UILabel *pingjiaLabel;


@property (weak, nonatomic) IBOutlet commentStar *star;

@property(strong,nonatomic)commerModel* comModel;

@end
