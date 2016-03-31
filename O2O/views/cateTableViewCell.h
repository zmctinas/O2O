//
//  cateTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carComModel.h"

@interface cateTableViewCell : UITableViewCell

@property(assign)id delegate;


@property(strong,nonatomic)carComModel* carModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;


@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *select;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



- (IBAction)numBtn:(UIButton *)sender;

- (IBAction)deleteBtn:(UIButton *)sender;

- (IBAction)selectBtn:(UIButton *)sender;

@end
