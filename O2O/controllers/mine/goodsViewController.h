//
//  goodsViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeAddressDelegate <NSObject>

-(void)changeAddress;

@end

@interface goodsViewController : fatherViewController

@property(assign,nonatomic)id<changeAddressDelegate> delegate;

@property(strong,nonatomic)NSMutableArray* tableSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
