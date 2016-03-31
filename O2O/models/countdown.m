//
//  countdown.m
//  O2O
//
//  Created by wangxiaowei on 15/5/4.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "countdown.h"

@implementation countdown
{
    NSTimer* _time;
    NSMutableArray* timesArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

-(void)changetime
{
    if ([_type isEqualToString:@"2"]) {
        UILabel* label = (UILabel*)[self viewWithTag:500];
        NSInteger second = [timesArr[2] integerValue];
        if (second>0) {
            second--;
            
        }else
        {
            second = 59;
            NSInteger mins = [timesArr[1] integerValue];
            if (mins>0) {
                mins--;
            }else
            {
                mins = 59;
                NSInteger hour = [timesArr[0] integerValue];
                if (hour>0) {
                    hour--;
                }
                else
                {
                    [_time setFireDate:[NSDate distantFuture]];
                    return;
                }
                timesArr[0] = [NSString stringWithFormat:@"%ld",hour];
            }
            timesArr[1] = [NSString stringWithFormat:@"%ld",mins];
        }
        timesArr[2] = [NSString stringWithFormat:@"%ld",second];
        label.text = [NSString stringWithFormat:@"%@时%@分%@秒",timesArr[0],timesArr[1],timesArr[2]];
    }else
    {
        UILabel* second = (UILabel*)[self viewWithTag:22];
        NSInteger ss = [second.text integerValue];
        if (ss>0) {
            ss--;
        }else
        {
            UILabel* minite = (UILabel*)[self viewWithTag:21];
            NSInteger min = [minite.text integerValue];
            if (min >0) {
                min--;
            }else
            {
                
                UILabel* hour = (UILabel*)[self viewWithTag:20];
                NSInteger hr = [hour.text integerValue];
                if (hr == 0) {
                    [_time setFireDate:[NSDate distantFuture]];
                    return;
                }
                hr--;
                hour.text = [NSString stringWithFormat:@"%.2ld",(long)hr];
                
                min = 59;
            }
            minite.text = [NSString stringWithFormat:@"%.2ld",(long)min];
            ss = 59;
        }
        second.text = [NSString stringWithFormat:@"%.2ld",(long)ss];
    }
    
}

-(void)setTimes:(NSString *)times
{
    
    _times = times;
    
    [self createtimer];
    
    [self createUI];
}

-(void)createtimer
{
    _time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changetime) userInfo:nil repeats:YES];
    [_time setFireDate:[NSDate distantFuture]];
}

-(NSMutableArray*)arrayWithTime:(NSString*)string
{
    NSMutableArray* time = [[NSMutableArray alloc]init];
    
    NSInteger num = [string integerValue];
    
    int i = 0;
    
    while (num) {
        i++;
        if (i>2) {
           [time addObject:[NSString stringWithFormat:@"%ld",(long)num]];
            break;
        }
        NSInteger h = num%60;
        [time addObject:[NSString stringWithFormat:@"%ld",(long)h]];
        num/=60;
    }
    while (time.count<3) {
        [time addObject:@"0"];
    }
    
    [time exchangeObjectAtIndex:2 withObjectAtIndex:0];
    
    return time;
}

-(void)createUI
{
    
    timesArr = [self arrayWithTime:_times];
    
    if ([_type isEqualToString:@"2"]) {
        UILabel* label = [[UILabel alloc]initWithFrame:self.bounds];
        label.text = [NSString stringWithFormat:@"%@时%@分%@秒",timesArr[0],timesArr[1],timesArr[2]];
        label.tag = 500;
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
    }else
    {
        for (int i = 0; i < 3; i++) {
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(5+i*(15+5), 8, 15, 15)];
            label.text = timesArr[i];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:11];
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 2;
            label.layer.masksToBounds = YES;
            label.tag = 20 + i;
            [self addSubview:label];
            if (i == 2) {
                break;
            }
            UILabel* hao = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 15)];
            hao.textAlignment = NSTextAlignmentCenter;
            hao.text = @":";
            hao.font = [UIFont systemFontOfSize:10];
            hao.center = CGPointMake(label.center.x + 10, label.center.y - 1);
            [self addSubview:hao];
        }
    }
    
    
    [_time setFireDate:[NSDate distantPast]];
}

@end
