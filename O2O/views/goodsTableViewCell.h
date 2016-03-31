//
//  goodsTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsViewController.h"
#import "adressModel.h"

@interface goodsTableViewCell : UITableViewCell<HTTPRequestDataDelegate>
{
    HTTPRequest* deleteReq;
}

@property(assign)id delegate;

@property(nonatomic)SEL action;

@property(strong,nonatomic)adressModel* model;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *youbianLabel;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


-(void)addselectBtnStatestarget:(id)delegate andAction:(SEL)action;

- (IBAction)addressBtn:(UIButton *)sender;

- (IBAction)deleteBtn:(UIButton *)sender;


@end
