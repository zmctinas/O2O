//
//  WXMapViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/7/1.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "demoModel.h"

#define apikey @"c587b217b0751ce1ff02a9a03f71308b";

@interface WXMapViewController : fatherViewController<MAMapViewDelegate>
{
    MAMapView* _mapView;
    AMapSearchAPI *_search;
    NSMutableArray* _tableSource;
}

@property(copy,nonatomic)NSString* latitude;
@property(copy,nonatomic)NSString* longitude;

@end
