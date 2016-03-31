//
//  commentTableViewCell.h
//  O2O
//
//  Created by wangxiaowei on 15/4/28.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"
#import "commentStar.h"


@interface commentTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet commentStar *star;

\

@property(strong,nonatomic)NSMutableArray* imageSource;

@property(strong,nonatomic)NSString* commentMessage;





@end
