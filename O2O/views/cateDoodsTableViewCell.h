//
//  cateDoodsTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cateDoodsTableViewCell : UITableViewCell

@property(strong,nonatomic)NSString* backView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightarr;


@end
