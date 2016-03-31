//
//  filtmenu.h
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface filtmenu : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UIButton* selectBtn;
}

@property(strong,nonatomic)UITableView* secondView;

@property(strong,nonatomic)UIView* headerView;
//
@property(assign)CGRect daxiao;

@end
