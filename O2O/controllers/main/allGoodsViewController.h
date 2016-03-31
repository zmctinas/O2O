//
//  allGoodsViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/4/17.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface allGoodsViewController : fatherViewController<UIScrollViewDelegate>

@property(copy,nonatomic)NSString* btnName;

@property(nonatomic,strong)UIButton* selectBtn;

@property(nonatomic,strong)NSString* typeid;

@property(nonatomic,strong)NSString* keyword;

@property(nonatomic,strong)NSString* low;

@property(nonatomic,strong)NSString* high;

@property(nonatomic,copy)NSString* act;

@property(nonatomic,strong)NSMutableArray* cateArr;

@property(nonatomic,strong)NSMutableArray* sortArr;

@property(nonatomic,strong)NSMutableArray* filtArr;

@end
