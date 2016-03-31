//
//  sharkViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/4.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "allMerModel.h"
#import "goodsDetailViewController.h"

@interface sharkViewController : fatherViewController<AVAudioPlayerDelegate>
{
    AVAudioPlayer* avPlayer;
}

@end
