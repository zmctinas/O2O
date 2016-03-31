//
//  cateCollectionViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/5/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collModel.h"
#import "allMerModel.h"

@interface cateCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)allMerModel* model;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
