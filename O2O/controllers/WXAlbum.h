//
//  WXAlbum.h
//  O2O
//
//  Created by wangxiaowei on 15/5/25.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXAlbum : UIView<UIScrollViewDelegate>

@property(strong,nonatomic)UIView* backView;

@property(strong,nonatomic)UIScrollView* scrollView;

@property(strong,nonatomic)UIPageControl* pageControl;

@property(strong,nonatomic)NSMutableArray* images;

@property(strong,nonatomic)NSMutableArray* imageUrls;

@property(assign,nonatomic)NSInteger currentIndex;

@property(strong,nonatomic)UIButton* deleteBtn;

@property(assign,nonatomic)id delegate;

@end
