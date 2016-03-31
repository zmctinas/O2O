//
//  recordTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"
#import "recordModel.h"

@interface recordTableViewCell : rootTableViewCell

@property(assign,nonatomic)NSInteger type;

@property(strong,nonatomic)recordModel* reModel;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@end
