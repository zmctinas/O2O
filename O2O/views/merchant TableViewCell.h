//
//  merchant TableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface merchant_TableViewCell : rootTableViewCell

- (IBAction)phoneBtn:(UIButton *)sender;

- (IBAction)conditionBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;



@end
