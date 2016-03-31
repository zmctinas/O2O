//
//  insertImage.h
//  O2O
//
//  Created by wangxiaowei on 15/5/25.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface insertImage : UIView<UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property(strong,nonatomic)NSMutableArray* images;

@property(assign,nonatomic)NSInteger maxnumImagecount;

@property(strong,nonatomic)UIImagePickerController* imagepicker;

@property(strong,nonatomic)UIButton* addImage;

@property(assign,nonatomic)id delegate;


-(void)showImages;

@end
