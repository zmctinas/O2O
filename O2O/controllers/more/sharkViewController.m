//
//  sharkViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/4.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "sharkViewController.h"

@interface sharkViewController ()<HTTPRequestDataDelegate>
{
    HTTPRequest* request;
    allMerModel* modle;
}

@property(strong,nonatomic)UIImageView* imageView1;
@property(strong,nonatomic)UIImageView* imageView2;

@end

@implementation sharkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    imageView.image = [UIImage imageNamed:@"wodeimg.9"];
    [self.view addSubview:imageView];
    
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
    
    NSString* string = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:string];
    avPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    avPlayer.delegate = self;
//    avPlayer.numberOfLoops = 1;
    [avPlayer prepareToPlay];
    
    request = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    if ([message isEqualToString:@"1"]) {
        NSDictionary* goods = requestDic[@"goods"];
        
        modle = [[allMerModel alloc]init];
        [modle setValuesForKeysWithDictionary:goods];
        goodsDetailViewController* root = [[goodsDetailViewController alloc]init];
        root.commid = modle.id;
        root.model = modle;
        [self.navigationController pushViewController:root animated:YES];
    }
}

#pragma mark - getter

-(UIImageView*)imageView1
{
    if (_imageView1 == nil) {
        _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _imageView1.image = [UIImage imageNamed:@"ys"];
    }
    return _imageView1;
}
-(UIImageView*)imageView2
{
    if (_imageView2 == nil) {
        _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _imageView2.image = [UIImage imageNamed:@"yx"];
    }
    return _imageView2;
}

#pragma mark - 摇一摇相关方法
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    [avPlayer play];
    
    [UIView animateWithDuration:1 animations:^{
        _imageView1.frame = CGRectMake(0, 64-200, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _imageView2.frame = CGRectMake(0, 64+200, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    } completion:^(BOOL finished) {
        _imageView1.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _imageView2.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }];
    
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        
        [request requestWitUrl:SHARK_IF andArgument:nil andType:WXHTTPRequestGet];
        
    }
    return;
}

@end
