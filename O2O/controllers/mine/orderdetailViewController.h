//
//  orderdetailViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/14.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"


@interface orderdetailViewController : fatherViewController

@property(strong,nonatomic)orderModel* ordModel;



@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (strong, nonatomic) IBOutlet UIView *contentview;

@property(copy,nonatomic)NSString* orderPrice;

@property(copy,nonatomic)NSString* totalPrice;

@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *ordernumLabel;

@property (weak, nonatomic) IBOutlet UILabel *chenggongLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property(copy,nonatomic)NSString* orderid;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

- (IBAction)commentBtn:(UIButton *)sender;

@end
