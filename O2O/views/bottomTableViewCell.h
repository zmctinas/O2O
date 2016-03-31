//
//  bottomTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/5/12.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "attModel.h"

@interface bottomTableViewCell : UITableViewCell<UITextViewDelegate>

@property(strong,nonatomic)attModel* model;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;




- (IBAction)numBtn:(UIButton *)sender;


@end
