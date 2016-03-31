//
//  creHeadTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/5/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"

@interface creHeadTableViewCell : rootTableViewCell<HTTPRequestDataDelegate>
{
    NSUserDefaults* defaults;
    HTTPRequest* goBuyReq;
}


@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *inteLabel;

- (IBAction)touchphotoBtn:(UIButton *)sender;

- (IBAction)goBuyBtn:(UIButton *)sender;


@end
