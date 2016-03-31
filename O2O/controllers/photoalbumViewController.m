//
//  photoalbumViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "photoalbumViewController.h"

@interface photoalbumViewController ()

@end

@implementation photoalbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView* backView = [[UIView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    [self.view addSubview:backView];
    
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageview.image = [UIImage imageNamed:_imageName];
    [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMG,_imageName]] placeholderImage:[UIImage imageNamed:@"loding1"]];
    imageview.center = self.view.center;
    [self.view addSubview:imageview];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];
    tap.numberOfTapsRequired =1;
    tap.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

-(void)tapBackView:(UITapGestureRecognizer*)tap
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
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
