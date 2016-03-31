//
//  headTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface headTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *lastPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

- (IBAction)getBuy:(UIButton *)sender;

- (IBAction)getDetailBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *addShopCar;

- (IBAction)addShopCar:(UIButton *)sender;


@end
