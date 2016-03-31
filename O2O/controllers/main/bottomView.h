//
//  bottomView.h
//  O2O
//
//  Created by wangxiaowei on 15/5/11.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bottomView : UIView<UITableViewDataSource,UITableViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* attrReq;
}

@property(strong,nonatomic)NSNumber* canbuynum;

@property(copy,nonatomic)NSString* gid;
@property(copy,nonatomic)NSString* comname;
@property(copy,nonatomic)NSString* price;

@property(assign)id delegate;

@property(assign)SEL action;

@property(strong,nonatomic)UIView* contentView;

@property(strong,nonatomic)UIView* btnView;

@property(strong,nonatomic)UIView* headView;

@property(strong,nonatomic)UITableView* tableView;

-(void)addorderDelegate:(id)delegate AndAction:(SEL)action;

@end
