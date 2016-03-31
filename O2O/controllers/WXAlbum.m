//
//  WXAlbum.m
//  O2O
//
//  Created by wangxiaowei on 15/5/25.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "WXAlbum.h"
#import "insertImage.h"

@implementation WXAlbum

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAlbum];
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - getter

-(UIView*)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_backView setBackgroundColor:[UIColor blackColor]];
        _backView.alpha = 0.7;
        _backView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

-(UIScrollView*)scrollView
{
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 450)];
        CGRect workingFrame = _scrollView.bounds;
        workingFrame.origin.x = 0;
        for (UIImage* image in _images) {
            UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
            [imageview setContentMode:UIViewContentModeScaleAspectFit];
            imageview.frame = workingFrame;
            
            [_scrollView addSubview:imageview];
            
            workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        }
        
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_images.count*SCREEN_WIDTH, 0);
        _scrollView.contentOffset = CGPointMake(_currentIndex*SCREEN_WIDTH, 0);
        
    }
    return _scrollView;
}

-(UIPageControl*)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, 80, 15)];
        _pageControl.numberOfPages = _images.count;
        _pageControl.currentPage = _currentIndex;
        
        _pageControl.center = CGPointMake(self.center.x, _pageControl.center.y);
    }
    return _pageControl;
}

#pragma mark - setter

-(void)setImageUrls:(NSMutableArray *)imageUrls
{
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (NSString* str in imageUrls) {
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,str];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 200)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [arr addObject:imageView.image];
            if (arr.count == imageUrls.count) {
                self.images = arr;
            }
        }];
        
    }
    
}

-(void)setImages:(NSMutableArray *)images
{
    _images = images;
    [self addSubview:self.backView];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(20, SCREEN_HEIGHT - 60, 60, 40)];
//    [button setImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:button];
//    
//    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_deleteBtn setFrame:CGRectMake(100, SCREEN_HEIGHT-60, 60, 40)];
//    [_deleteBtn setBackgroundColor:[UIColor whiteColor]];
//    [_deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_deleteBtn];
}

#pragma mark - private

-(void)tapBackView:(UITapGestureRecognizer*)tap
{
    [self removeFromSuperview];
}

-(void)initAlbum
{
    _images = [[NSMutableArray alloc]init];
    
}

-(void)deleteBtn:(UIButton*)sender
{
    [_images removeObjectAtIndex:_currentIndex];
    
    __weak insertImage* insert = (insertImage*)_delegate;
    [insert showImages];
    
    [self removeFromSuperview];
}

-(void)goback:(UIButton*)sender
{
    [self removeFromSuperview];
}

-(void)changePageWithScrollview:(CGFloat)index
{
    _pageControl.currentPage = index;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat num = scrollView.contentOffset.x/SCREEN_WIDTH;
    [self changePageWithScrollview:num];
}

@end
