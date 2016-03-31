//
//  sortmenu.h
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sortmenu : UIView<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>

{
    HTTPRequest* request;
}

@property(strong,nonatomic)NSMutableArray* tableSource;

@property(assign)CGRect daxiao;

@property(strong,nonatomic)UIView* headerView;

@property(assign)NSInteger type;

@property(copy,nonatomic)NSString* contro;

@end
