//
//  insertImage.m
//  O2O
//
//  Created by wangxiaowei on 15/5/25.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "insertImage.h"
#import "WXAlbum.h"
#import "AppDelegate.h"

@implementation insertImage

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initImageView];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initImageView];
    }
    return self;
}

#pragma mark - private

-(void)initImageView
{
    _addImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _addImage.frame = CGRectMake(_images.count%4*(50+20)+20, 10+_images.count/4*(50+10), 50, 50);
    [_addImage setImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
    _addImage.tag = 100;
    [_addImage addTarget:self action:@selector(addimage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addImage];
    
    _images = [[NSMutableArray alloc]init];
    _maxnumImagecount =4;
}

-(void)addimage:(UIButton*)sender
{
    
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self];
}

-(void)createImagePicker
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = _maxnumImagecount - _images.count; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    UIViewController* VC = (UIViewController*)_delegate;
    [VC presentViewController:elcPicker animated:YES completion:nil];

}

-(void)createCameraPicker
{
    _imagepicker = [[UIImagePickerController alloc]init];
    _imagepicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
    _imagepicker.delegate = self;
    _imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagepicker.mediaTypes = @[(NSString *)kUTTypeImage];
    UIViewController* VC = (UIViewController*)_delegate;
    [VC presentViewController:_imagepicker animated:YES completion:nil];
}

-(void)showImages
{
    
    
    
    NSArray* arr = [self subviews];
    for (id obj in arr) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView* imageView = (UIImageView*)obj;
            [imageView removeFromSuperview];
        }else if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*)obj;
            if (button.tag != 100) {
                [button removeFromSuperview];
            }
            
        }
    }
    
    int w=0,h=0;
    
    for (UIImage* image in _images) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+w*(50+20), 10+h*(50+10), 50, 50)];
        imageView.image = image;
        imageView.tag = w+h*4;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 10, 10)];
        button.center = CGPointMake(20+w*(50+20)+50, 10+h*(50+10));
        [button setImage:[UIImage imageNamed:@"other"] forState:UIControlStateNormal];
        button.tag = w+h*4;
        [button addTarget:self action:@selector(delegateBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        w++;
        if (w==4) {
            h++;
            w=0;
        }
    }
    [self changeInsertBtn];
}

-(void)delegateBtn:(UIButton*)sender
{
    [_images removeObjectAtIndex:sender.tag];
    [self showImages];
}

-(void)tapImageView:(UITapGestureRecognizer*)tap
{
    UIImageView* imageView = (UIImageView*)tap.view;
    
    UIApplication* application = [UIApplication sharedApplication];
    AppDelegate* delegate = application.delegate;
    UIWindow* window = delegate.window;
    WXAlbum* album = [[WXAlbum alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    album.currentIndex = imageView.tag;
    album.delegate = self;
    album.images = _images;
    
    [window addSubview:album];
}

-(void)changeInsertBtn
{
    if (_maxnumImagecount - _images.count > 0) {
        _addImage.hidden = NO;
        _addImage.frame = CGRectMake(_images.count%4*(50+20)+20, 10+_images.count/4*(50+10), 50, 50);
    }else
    {
        _addImage.hidden = YES;
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    
    [_images addObject:orgImage];
    
    [self showImages];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagepicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    UIViewController* VC = (UIViewController*)_delegate;
    [VC dismissViewControllerAnimated:YES completion:nil];
    
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [_images addObject:image];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [_images addObject:image];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    [self showImages];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [self createImagePicker];
            break;
        case 1:
            [self createCameraPicker];
            
        default:
            break;
    }
    
}

@end
