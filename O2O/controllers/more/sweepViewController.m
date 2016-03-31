//
//  sweepViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/4.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "sweepViewController.h"
#import "sweepWebViewController.h"


@interface sweepViewController ()
{
    UIImageView* _imageView;
    UIWebView* webView;
}
@property(strong,nonatomic)UILabel* label;

@end


@implementation sweepViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
        
    }
    
    return self;
    
}

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    [self.view addSubview:webView];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.titleView = self.label;
    
    
    
    
    
//    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    
//    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
//    
//    scanButton.frame = CGRectMake(100, 420, 120, 40);
//    
//    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:scanButton];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    _imageView.center = self.view.center;
    _imageView.image = [UIImage imageNamed:@"frame"];
    
    [self.view addSubview:_imageView];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 150, 50)];
    
    labIntroudction.backgroundColor = [UIColor clearColor];
    
    labIntroudction.numberOfLines=2;
    labIntroudction.font = [UIFont systemFontOfSize:12];
    
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    
    labIntroudction.text=@"将二维码图案放在取景框内    即可自动扫描";
    labIntroudction.center = CGPointMake(self.view.center.x, _imageView.center.y+150);
    [self.view addSubview:labIntroudction];
    
    
    
    upOrdown = NO;
    
    num =0;
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 160, 2)];
    
    _line.image = [UIImage imageNamed:@"line.png"];
    _line.center = CGPointMake(_imageView.center.x, _imageView.frame.origin.y);
    
    
    [self.view addSubview:_line];
    
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
    
    
    
    
    
}

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        _label.text = @"扫一扫";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:15];
    }
    return _label;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
    
    if(authStatus ==AVAuthorizationStatusRestricted){
        
        NSLog(@"Restricted");
        
    }else if(authStatus == AVAuthorizationStatusDenied){
        
        // The user has explicitly denied permission for media capture.
        
        NSLog(@"Denied");     //应该是这个，如果不允许的话
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                              
                                                        message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                              
                                                       delegate:self
                              
                                              cancelButtonTitle:@"确定"
                              
                                              otherButtonTitles:nil];
        
        [alert show];
        
        
        
        return;
        
    }
    
    else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        
        // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
        
        NSLog(@"Authorized");
        
        
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            
            if(granted){//点击允许访问时调用
                
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                
                NSLog(@"Granted access to %@", mediaType);
                
            }
            
            else {
                
                NSLog(@"Not granted access to %@", mediaType);
                
            }
            
            
            
        }];
        
    }else {
        
        NSLog(@"Unknown authorization status");
        
    }
    
    [self setupCamera];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}

-(void)animation1

{
    
    if (upOrdown == NO) {
        
        num ++;
        
        _line.frame = CGRectMake(_line.frame.origin.x, _line.frame.origin.y+2, 160, 2);
        
        if (2*num == 200) {
            
            upOrdown = YES;
            
        }
        
    }
    
    else {
        
        num --;
        
        _line.frame = CGRectMake(_line.frame.origin.x, _line.frame.origin.y-2, 160, 2);
        
        if (num == 0) {
            
            upOrdown = NO;
            
        }
        
    }
    
    
}

-(void)backAction
{
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [timer invalidate];
        
    }];
    
}



- (void)setupCamera

{
    
    // Device
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    
    _session = [[AVCaptureSession alloc]init];
    
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        
        [_session addInput:self.input];
        
    }
    
    if ([_session canAddOutput:self.output])
    {
        
        [_session addOutput:self.output];
        
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    [_output setRectOfInterest:CGRectMake(_imageView.frame.origin.y/self.view.frame.size.height, _imageView.frame.origin.x/self.view.frame.size.width, _imageView.frame.size.height/self.view.frame.size.height, _imageView.frame.size.width/self.view.frame.size.width)];
    
    
    // Preview
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
//    _preview.frame =CGRectMake(20,110,280,280);
    _preview.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    // Start
    
    [_session startRunning];
    
    
    
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        stringValue = metadataObject.stringValue;
//        sweepWebViewController* root = [[sweepWebViewController alloc]init];
//        root.urlStr = stringValue;
//        [self.navigationController pushViewController:root animated:YES];
        NSLog(@"%@",stringValue);
//        NSURL* url = [NSURL URLWithString:stringValue];
//        webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        [self.view addSubview:webView];
//        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    [_session stopRunning];
//    [timer setFireDate:[NSDate distantFuture                                                                                                                                                                                  ]];
//    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
