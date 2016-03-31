//
//  credetTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/5/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface credetTableViewCell : rootTableViewCell
{
    NSUserDefaults* defaults;
}



@property (weak, nonatomic) IBOutlet UIView *numBackView;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *timedescriptions;

@property (weak, nonatomic) IBOutlet UIButton *shangBtn;

@property (weak, nonatomic) IBOutlet UIButton *songBtn;

@property (weak, nonatomic) IBOutlet UILabel *xiaojieLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;


- (IBAction)selectBtn:(UIButton *)sender;

- (IBAction)numBtn:(UIButton *)sender;

- (IBAction)changeAddress:(UIButton *)sender;

@end
