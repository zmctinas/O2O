//
//  multmenu.h
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface multmenu : UIView<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    BOOL isfirst;
}


@property(strong,nonatomic)UITableView* secondView;

@property(strong,nonatomic)UIView* headerView;
//
@property(assign)CGRect daxiao;

@property(strong,nonatomic)NSString* contro;

@end
