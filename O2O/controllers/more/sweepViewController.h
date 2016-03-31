//
//  sweepViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/5/4.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface sweepViewController : fatherViewController<AVCaptureMetadataOutputObjectsDelegate>

{
    
    int num;
    
    BOOL upOrdown;
    
    NSTimer * timer;
    
}

@property (strong,nonatomic)AVCaptureDevice * device;

@property (strong,nonatomic)AVCaptureDeviceInput * input;

@property (strong,nonatomic)AVCaptureMetadataOutput * output;

@property (strong,nonatomic)AVCaptureSession * session;

@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, retain) UIImageView * line;

@end
